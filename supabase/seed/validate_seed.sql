with seeded_subjects as (
  select id, name from public.subjects where name in ('Mathematics', 'Physics', 'Chemistry', 'Biology', 'Computer Science', 'Data Structures and Algorithms', 'Database Management Systems', 'Operating Systems', 'Aptitude and Reasoning', 'English') and is_active = true
), seeded_topics as (
  select t.id, t.name, s.name as subject_name
  from public.topics t
  join seeded_subjects s on s.id = t.subject_id
  where t.is_active = true
), seeded_exams as (
  select id, title, seed_key, subject_id
  from public.exams
  where seed_key in ('demo:exam:mathematics', 'demo:exam:physics', 'demo:exam:chemistry', 'demo:exam:biology', 'demo:exam:computer_science', 'demo:exam:data_structures_and_algorithms', 'demo:exam:database_management_systems', 'demo:exam:operating_systems', 'demo:exam:aptitude_and_reasoning', 'demo:exam:english')
    and status = 'published'
    and is_published = true
    and is_active = true
), seeded_questions as (
  select q.*
  from public.questions q
  where q.seed_key like 'demo:question:%'
    and q.is_active = true
)
select 'subjects' as metric, count(*)::text as actual, '10' as expected, (count(*) = 10) as ok from seeded_subjects
union all
select 'topics', count(*)::text, '50', (count(*) = 50) from seeded_topics
union all
select 'questions', count(*)::text, '500', (count(*) = 500) from seeded_questions
union all
select 'published comprehensive exams', count(*)::text, '10', (count(*) = 10) from seeded_exams
union all
select 'questions without topic', count(*)::text, '0', (count(*) = 0) from seeded_questions where topic_id is null
union all
select 'questions without explanation', count(*)::text, '0', (count(*) = 0) from seeded_questions where coalesce(trim(explanation), '') = ''
union all
select 'invalid correct_answer values', count(*)::text, '0', (count(*) = 0) from seeded_questions where correct_answer not between 0 and 3
union all
select 'questions with option count != 4', count(*)::text, '0', (count(*) = 0) from seeded_questions where jsonb_array_length(options) <> 4
union all
select 'duplicate options inside a question', count(*)::text, '0', (count(*) = 0)
from seeded_questions q
where exists (
  select 1
  from (
    select value, count(*)
    from jsonb_array_elements_text(q.options)
    group by value
    having count(*) > 1
  ) dup
)
union all
select 'questions per subject = 50', count(*)::text, '10', (count(*) = 10)
from (
  select subject_id from seeded_questions group by subject_id having count(*) = 50
) s
union all
select 'questions per topic = 10', count(*)::text, '50', (count(*) = 50)
from (
  select topic_id from seeded_questions group by topic_id having count(*) = 10
) t
union all
select 'easy per subject = 15', count(*)::text, '10', (count(*) = 10)
from (
  select subject_id from seeded_questions where difficulty = 'easy' group by subject_id having count(*) = 15
) e
union all
select 'medium per subject = 20', count(*)::text, '10', (count(*) = 10)
from (
  select subject_id from seeded_questions where difficulty = 'medium' group by subject_id having count(*) = 20
) m
union all
select 'hard per subject = 15', count(*)::text, '10', (count(*) = 10)
from (
  select subject_id from seeded_questions where difficulty = 'hard' group by subject_id having count(*) = 15
) h
union all
select 'questions mapped to each exam = 50', count(*)::text, '10', (count(*) = 10)
from (
  select eq.exam_id
  from public.exam_questions eq
  join seeded_exams e on e.id = eq.exam_id
  group by eq.exam_id
  having count(*) = 50
) mapped;

select s.name as subject,
       count(q.id) as total_questions,
       count(*) filter (where q.difficulty = 'easy') as easy_questions,
       count(*) filter (where q.difficulty = 'medium') as medium_questions,
       count(*) filter (where q.difficulty = 'hard') as hard_questions
from seeded_subjects s
left join seeded_questions q on q.subject_id = s.id
group by s.name
order by s.name;

select e.title as exam_title,
       count(eq.question_id) as mapped_questions
from seeded_exams e
left join public.exam_questions eq on eq.exam_id = e.id
group by e.title
order by e.title;
