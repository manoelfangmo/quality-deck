-- Alternate jobs: a job can replace another job in a proposal package.
--
-- Error tokens (SQLSTATE class Q0):
--   Q0074 job_not_found (reused)
--   Q0082 invalid_alternate_job
--   Q0083 job_has_alternates

alter table public.jobs
  add column alternate_of_job_id uuid references public.jobs (id)
    on delete restrict;

create index jobs_alternate_of_job_id_idx
  on public.jobs (alternate_of_job_id)
  where alternate_of_job_id is not null;

create function public.jobs_validate_alternate()
returns trigger
language plpgsql
set search_path = public
as $$
declare
  target public.jobs;
begin
  if new.alternate_of_job_id is null then
    return new;
  end if;

  if new.alternate_of_job_id = new.id then
    raise exception 'invalid_alternate_job' using errcode = 'Q0082';
  end if;

  select * into target
  from public.jobs
  where id = new.alternate_of_job_id;

  if target is null then
    raise exception 'job_not_found' using errcode = 'Q0074';
  end if;

  if target.project_id is distinct from new.project_id then
    raise exception 'invalid_alternate_job' using errcode = 'Q0082';
  end if;

  if target.alternate_of_job_id is not null then
    raise exception 'invalid_alternate_job' using errcode = 'Q0082';
  end if;

  if exists (
    select 1
    from public.jobs
    where alternate_of_job_id = new.id
  ) then
    raise exception 'invalid_alternate_job' using errcode = 'Q0082';
  end if;

  return new;
end;
$$;

create trigger jobs_validate_alternate
  before insert or update of alternate_of_job_id, project_id
  on public.jobs
  for each row execute function public.jobs_validate_alternate();

create function public.jobs_prevent_delete_if_alternates()
returns trigger
language plpgsql
set search_path = public
as $$
begin
  if exists (
    select 1
    from public.jobs
    where alternate_of_job_id = old.id
  ) then
    raise exception 'job_has_alternates' using errcode = 'Q0083';
  end if;
  return old;
end;
$$;

create trigger jobs_prevent_delete_if_alternates
  before delete on public.jobs
  for each row execute function public.jobs_prevent_delete_if_alternates();

grant insert (alternate_of_job_id) on table public.jobs to authenticated;
grant update (alternate_of_job_id) on table public.jobs to authenticated;
