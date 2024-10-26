# travel

여행객들을 위한 앱을 만들 계획임

# 기획

> 피드

- 여행을 하고 일기(?)를 포스팅 형태로 작성
- 이 때 시간과 위치, 해시태그 등을 추가
- 공유기능을 통해서 좋아요 댓글 기능 추가함

> 여행 메이트 찾기

- 같이 여행할 사람을 찾는 공지글 작성 및 조회 기능 만들기
- 댓글 기능 추가하기

> 채팅기능

# Supabase

`supabse init`
`supabase start`
`supabase status`

# Reference

    > Google ML Kit 

    - Image To Text

        https://pub.dev/packages/google_mlkit_text_recognition

# Script


## Create Tables
```
-- create account table
create table public.accounts (
    id uuid not null ,
    email text not null unique,
    username text null,
    avatar_url text null,
    constraint accounts_pkey primary key (id),
    constraint accounts_fkey foreign key (id) 
    references auth.users (id) on update cascade on delete cascade
) tablespace pg_default;

alter table public.accounts enable row level security;

create policy "enable to select for all authenticated" 
on accounts for select using (true);

create policy "enable insert only own data" on accounts
for insert to authenticated with check (auth.uid() = id);

create policy "enable update only own data" on accounts
for update to authenticated with check (auth.uid() = id);

create policy "enable delete only own data" on accounts
for delete to authenticated using (auth.uid() = id);

-- create diary
create table public.diaries (
    id uuid not null default gen_random_uuid (),
    created_by uuid not null default auth.uid(),
    images text[] DEFAULT '{}',
    hashtags text[] DEFAULT '{}',
    captions text[] DEFAULT '{}',
    location text,
    content text,
    is_private bool DEFAULT true,
    created_at timestamp with time zone not null default now(),
    updated_at timestamp with time zone null,    
    constraint diaries_pkey primary key (id),
    constraint diaries_fkey foreign key (created_by)
    references accounts (id) on update cascade on delete cascade
) tablespace pg_default;

alter table public.diaries enable row level security;

create policy "enable to select for all authenticated" 
on diaries for select to authenticated using (true);

create policy "enable insert only own data" on diaries
for insert to authenticated with check (auth.uid() = created_by);

create policy "enable update only own data" on diaries
for update to authenticated with check (auth.uid() = created_by);

create policy "enable delete only own data" on diaries
for delete to authenticated using (auth.uid() = created_by);

-- create open chat
create table public.open_chats (
    id uuid not null default gen_random_uuid(),
    title text,
    hashtags text[] DEFAULT '{}',
    last_message_content text,
    last_message_created_at timestamp with time zone not null default now(),
    created_at timestamp with time zone not null default now(),
    created_by uuid not null default auth.uid(),
    constraint open_chat_pkey primary key (id),
    constraint open_chat_fkey foreign key (created_by)
    references accounts (id) on update cascade on delete cascade
) tablespace pg_default;

alter table public.open_chats enable row level security;

create policy "enable to select for all authenticated" 
on open_chats for select to authenticated using (true);

create policy "enable insert only own data" on open_chats
for insert to authenticated with check (true);

create policy "enable update only own data" on open_chats
for update to authenticated with check (true);

create policy "enable delete only own data" on open_chats
for delete to authenticated using (auth.uid() = created_by);

-- create private chat
create table public.private_chats (
    id uuid not null default gen_random_uuid(),
    uid uuid not null,
    opponent_uid uuid not null,
    last_message_content text,
    last_message_created_at timestamp with time zone not null default now(),
    created_at timestamp with time zone not null default now(),
    constraint private_chat_pkey primary key (id),
    constraint private_chat_fkey1 foreign key (uid)
    references accounts (id) on update cascade on delete cascade,
    constraint private_chat_fkey2 foreign key (opponent_uid)
    references accounts (id) on update cascade on delete cascade
) tablespace pg_default;

alter table public.private_chats enable row level security;

create policy "enable to select for all authenticated" 
on private_chats for select to authenticated using 
((auth.uid()=uid) or (auth.uid()=opponent_uid));

create policy "enable insert only own data" on private_chats
for insert to authenticated with check
((auth.uid()=uid) or (auth.uid()=opponent_uid));

create policy "enable update only own data" on private_chats
for update to authenticated with check
((auth.uid()=uid) or (auth.uid()=opponent_uid));

create policy "enable delete only own data" on private_chats
for delete to authenticated using
((auth.uid()=uid) or (auth.uid()=opponent_uid));

-- create open chat message
create table public.open_chat_messages (
    id uuid not null default gen_random_uuid(),
    chat_id uuid not null,
    content text,
    media text,
    last_message_created_at timestamp with time zone not null default now(),
    created_at timestamp with time zone not null default now(),
    created_by uuid not null default auth.uid(),
    constraint open_chat_message_pkey primary key (id),
    constraint open_chat_message_fkey foreign key (created_by)
    references accounts (id) on update cascade on delete cascade
) tablespace pg_default;

alter table public.open_chat_messages enable row level security;

create policy "enable to select for all authenticated" 
on open_chat_messages for select to authenticated using (true);

create policy "enable insert only own data" on open_chat_messages
for insert to authenticated with check (true);

create policy "enable update only own data" on open_chat_messages
for update to authenticated with check (auth.uid()=created_by);

-- create private chat message
create table public.private_chat_messages (
    id uuid not null default gen_random_uuid(),
    chat_id uuid not null,
    sender uuid not null,
    receiver uuid not null,
    content text,
    media text,
    created_at timestamp with time zone not null default now(),
    removed_at timestamp with time zone,
    created_by uuid not null default auth.uid(),
    constraint private_chat_messages_pkey primary key (id),
    constraint private_chat_messages_fkey1 foreign key (sender)
    references accounts (id) on update cascade on delete cascade,
    constraint private_chat_messages_fkey2 foreign key (receiver)
    references accounts (id) on update cascade on delete cascade
) tablespace pg_default;

alter table public.private_chat_messages enable row level security;

create policy "enable to select for all authenticated" 
on private_chat_messages for select to authenticated using 
((auth.uid()=sender) or (auth.uid()=receiver));

create policy "enable insert only own data" on private_chat_messages
for insert to authenticated with check
((auth.uid()=sender) or (auth.uid()=receiver));

create policy "enable update only own data" on private_chat_messages
for update to authenticated with check
((auth.uid()=sender) or (auth.uid()=receiver) and (auth.uid() = created_by));

create policy "enable delete only own data" on private_chat_messages
for delete to authenticated using
((auth.uid()=sender) or (auth.uid()=receiver) and (auth.uid() = created_by));

-- create meeting
create table public.meetings (
    id uuid not null default gen_random_uuid(),
    country text not null,
    city text,
    start_date timestamp with time zone not null,
    end_date timestamp with time zone not null,
    head_count int default 2,
    sex text default 'all',
    theme text default 'all',
    min_cost int default 0,
    max_cost int default 10,
    title text,
    content text,
    hashtags text[] DEFAULT '{}',
    thumbnail text,
    created_at timestamp with time zone not null default now(),
    updated_at timestamp with time zone not null,
    created_by uuid not null default auth.uid(),
    constraint meetings_pkey primary key (id),
    constraint meetings_fkey foreign key (created_by)
    references accounts (id) on update cascade on delete cascade
) tablespace pg_default;

alter table public.meetings enable row level security;

create policy "enable to select for all authenticated" 
on meetings for select to authenticated using (true);

create policy "enable insert only own data" on meetings
for insert to authenticated with check (true);

create policy "enable update only own data" on meetings
for update to authenticated with check (auth.uid()=created_by);

create policy "enable delete only own data" on meetings
for delete to authenticated using (auth.uid()=created_by);

-- create registration table
create table public.registrations (
    id uuid not null default gen_random_uuid(),
    meeting_id uuid not null,
    manager_id uuid not null,
    proposer_id uuid not null default auth.uid(),       -- 등록 신청한 유저 id
    is_permitted bool default false,                   -- 등록 신청 허용 여부
    created_by uuid not null default auth.uid(),
    INTRODUCE text,
    created_at timestamp with time zone not null default now(),
    updated_at timestamp with time zone not null,
    constraint registration_pkey primary key (id),
    UNIQUE (meeting_id, created_by),   -- meeting id와 등록신청한 유저 id로 unique 조건 걸기
    constraint registration_fkey1 foreign key (meeting_id)
    references meetings (id) on update cascade on delete cascade,
    constraint registration_fkey2 foreign key (created_by)
    references accounts (id) on update cascade on delete cascade,
    constraint registration_fkey3 foreign key (manager_id)
    references accounts (id) on update cascade on delete cascade
) tablespace pg_default;

alter table public.registrations enable row level security;

create policy "enable to select for all authenticated" 
on registrations for select to authenticated using (true);

create policy "enable insert only own data" on registrations
for insert to authenticated with check (auth.uid()=created_by);

create policy "enable update only own data" on registrations
for update to authenticated 
USING (auth.uid() = manager_id)
with check (auth.uid()=manager_id);

create policy "enable delete only own data" on registrations
for delete to authenticated using ((auth.uid()=proposer_id) or (auth.uid()=manager_id));

-- 댓글 테이블
create table public.comments (
    id uuid not null default gen_random_uuid(),
    reference_table text not null,
    reference_id uuid not null,
    content text,
    created_by uuid not null default auth.uid(),
    created_at timestamp with time zone not null default now(),
    updated_at timestamp with time zone not null,
    constraint comments_pkey primary key (id),
    constraint comments_fkey foreign key (created_by)
    references accounts (id) on update cascade on delete cascade
) tablespace pg_default;

alter table public.comments enable row level security;

create policy "enable to select for all authenticated" 
on comments for select to authenticated using (true);

create policy "enable insert only own data" on comments
for insert to authenticated with check (auth.uid()=created_by);

create policy "enable update only own data" on comments
for update to authenticated with check (auth.uid()=created_by);

create policy "enable delete only own data" on comments
for delete to authenticated using (auth.uid()=created_by);

```

## Create Buckets

```
-- avatar bucket
insert into storage.buckets (id, name)
values ('avatar', 'avatar');

create policy "permit select avatar for all" on storage.objects
for select using (bucket_id = 'avatar');

create policy "permit insert avatar for all" on storage.objects
for insert with check (bucket_id = 'avatar');

-- diary bucket
insert into storage.buckets (id, name)
values ('diary', 'diary');

create policy "permit select diary for all" on storage.objects
for select using (bucket_id = 'diary');

create policy "permit insert for all" on storage.objects
for insert with check (bucket_id = 'diary');

-- meeting bucket
insert into storage.buckets (id, name)
values ('meeting', 'meeting');

create policy "permit select meeting for all" on storage.objects
for select using (bucket_id = 'meeting');

create policy "permit insert meeting for all" on storage.objects
for insert with check (bucket_id = 'meeting');
```

## Rpc Function
```
-- on sign up
create or replace function public.on_sign_up()
returns trigger
language plpgsql
security definer set search_path = public
as $$
    begin
    insert into public.accounts (
        id,
        email, 
        username, 
        avatar_url
    )
    values (
        new.id, 
        new.email,
        new.raw_user_meta_data->>'username', 
        new.raw_user_meta_data->>'avatar_url'
    );
    return new;
    end;
$$;

create trigger on_auth_user_created
after insert on auth.users
for each row execute procedure public.on_sign_up();

------------------------------------------------------

-- on edit profile
create or replace function public.on_edit_profile()
returns trigger
language plpgsql
security definer set search_path = public
as $$
    begin
    update public.accounts 
    set username = new.raw_user_meta_data->>'username', 
        avatar_url = new.raw_user_meta_data->>'avatar_url'
    where id = new.id;
    return new;
    end;
$$;

create trigger on_auth_edited
after update on auth.users
for each row execute procedure public.on_edit_profile();

------------------------------------------------------

-- on fetch diary
create or replace function fetch_diaries
(before_at timestamptz, take int)
returns table(
    id uuid, 
    images text[],
    hashtags text[],
    captions text[],
    location text,
    content text,
    is_private bool,
    created_at timestamptz,
    updated_at timestamptz,
    created_by uuid,
    username text,
    avatar_url text
)
language sql
as $$
    select
      A.id,
      A.images,
      A.hashtags,
      A.captions,
      A.location,
      A.content,
      A.is_private,
      A.created_at,
      A.updated_at,
      A.created_by author_uid,
      B.username author_username,
      B.avatar_url author_avatar_url
    from (
        select
          id,
          images,
          hashtags,
          captions,
          location,
          content,
          is_private,
          created_by,
          created_at,
          updated_at
        from
            public.diaries
        where
            created_at < before_at
            and ((is_private = false) or (created_by = auth.uid()))
        order by created_at desc
        limit(take)
        ) A
    left join public.accounts B on A.created_by = B.id
;
$$

-- on fetch meeting
create or replace function fetch_meetings
(before_at timestamptz, take int)
returns table(
    country text,
    city text,
    start_date timestamptz,
    end_date timestamptz,
    head_count int,
    sex text,
    theme text ,
    min_cost int,
    max_cost int,
    title text,
    content text,
    hashtags text[],
    thumbnail text,
    id uuid, 
    created_at timestamptz,
    updated_at timestamptz,
    author_uid uuid,
    author_username text,
    author_avatar_url text
)
language sql
as $$
    select
          A.country,
          A.city,
          A.start_date,
          A.end_date,
          A.head_count,
          A.sex,
          A.theme,
          A.min_cost,
          A.max_cost,
          A.title,
          A.content,
          A.hashtags,
          A.thumbnail,
          A.id,
          A.created_at,
          A.updated_at,
          A.created_by author_uid,
          B.username author_username,
          B.avatar_url author_avatar_url
    from (
        select
          country,
          city,
          start_date,
          end_date,
          head_count,
          sex,
          theme,
          min_cost,
          max_cost,
          title,
          content,
          hashtags,
          thumbnail,
          id,
          created_at,
          updated_at,
          created_by
        from
            public.meetings
        where
            created_at < before_at
        order by created_at desc
        limit(take)
        ) A
    left join public.accounts B on A.created_by = B.id
;
$$

CREATE OR REPLACE FUNCTION create_registration(
    meeting_id_to_insert uuid,
    introduce_to_insert text
)
RETURNS UUID AS $$
DECLARE
    max_head_count int;         -- 최대 인원
    currernt_head_count int;    -- 현재 승인된 인원
    manager_uid uuid;
    new_registration_id uuid;
BEGIN
    -- 변수에 값 할당하기
    SELECT head_count, created_by INTO max_head_count, manager_uid
    FROM meetings
    WHERE id = meeting_id_to_insert;
    
    SELECT count(1) INTO currernt_head_count
    FROM registrations
    WHERE meeting_id = meeting_id_to_insert
    and is_permitted = true;
 
    -- 에러처리
    if not found then
        RAISE EXCEPTION 'meeting with id % does not exist', meeting_id;
    ELSIF max_head_count <= currernt_head_count then
        RAISE EXCEPTION 'head count can not exceed %', max_head_count;
    end if;

    INSERT INTO registrations (
        meeting_id,
        manager_id,
        proposer_id,
        is_permitted,
        introduce,
        created_by,
        created_at,
        updated_at
    ) VALUES (
        meeting_id_to_insert,
        manager_uid,
        auth.uid(),
        manager_uid = auth.uid(),
        introduce_to_insert,
        auth.uid(),
        NOW() AT TIME ZONE 'UTC',
        NOW() AT TIME ZONE 'UTC'
    )
    RETURNING id INTO new_registration_id;
    RETURN new_registration_id;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION fetch_registrations(meeting_id_to_fetch uuid)
RETURNS table(
    ID uuid,
    MEETING_ID UUID,
    MANAGER_ID UUID,
    MANAGER_USERNAME TEXT,
    MANAGER_AVATAR_URL TEXT,
    CREATED_BY UUID,
    PROPOSER_ID UUID,
    PROPOSER_USERNAME TEXT,
    PROPOSER_AVATAR_URL TEXT,
    IS_PERMITTED BOOL,
    INTRODUCE text,
    CREATED_AT timestamptz
)
AS $$
BEGIN
    RETURN QUERY
    SELECT 
        R.ID,                            
        R.MEETING_ID,                   
        R.MANAGER_ID,
        MGR.USERNAME AS MANAGER_USERNAME,
        MGR.AVATAR_URL AS MANAGER_AVATAR_URL,
        R.CREATED_BY,                  
        R.PROPOSER_ID,              
        PRP.USERNAME AS PROPOSER_USERNAME, 
        PRP.AVATAR_URL AS PROPOSER_AVATAR_URL,
        R.IS_PERMITTED,           
        R.INTRODUCE,            
        R.CREATED_AT
    FROM public.REGISTRATIONS R
    LEFT JOIN public.ACCOUNTS PRP ON R.PROPOSER_ID = PRP.ID
    LEFT JOIN public.ACCOUNTS MGR ON R.MANAGER_ID = MGR.ID
    where R.MEETING_ID = meeting_id_to_fetch;
END;
$$ LANGUAGE plpgsql;


-- on meeting created
CREATE OR REPLACE FUNCTION PUBLIC.ON_MEETING_CREATED()
returns trigger
language plpgsql
security definer set search_path = public
as $$
    begin
    PERFORM create_registration(NEW.ID, 'meeting created');
    RETURN NEW;
    end;
$$;

create trigger on_meeting_created
after insert on public.meetings
for each row execute procedure PUBLIC.ON_MEETING_CREATED();


CREATE OR REPLACE FUNCTION fetch_comments(
    reference_id_to_fetch uuid,
    reference_table_to_fetch text,
    before_at timestamptz, 
    take int
) RETURNS table(
    id uuid,
    reference_table text,
    reference_id UUID,
    content text,
    author_uid uuid,
    author_username text,
    author_avatar_url text,
    created_at timestamptz,
    updated_at timestamptz
)
language sql
as $$
    select
        A.id,
        A.reference_table,
        A.reference_id,
        A.content,
        A.created_by author_uid,
        B.username author_username,
        B.avatar_url author_avatar_url,
        A.created_at,
        A.updated_at
    from (
        select
            id,
            reference_table,
            reference_id,
            content,
            created_by,
            created_at,
            updated_at
        from
            public.comments
        where
            created_at < before_at
            and reference_table = reference_table_to_fetch
            and reference_id = reference_id_to_fetch
        order by created_at desc
        limit(take)
        ) A
    left join public.accounts B on A.created_by = B.id;
$$

CREATE OR REPLACE FUNCTION update_permission_on_registration(
    registration_id_to_permit uuid,
    is_permitted_to_switch bool
)
RETURNS void AS $$
DECLARE
    updated_count int;
    max_head_count int;
    current_permitted_head_count int;
    current_meeting_id uuid;
    current_manager_id uuid;
BEGIN
    SELECT meeting_id, manager_id 
    INTO current_meeting_id, current_manager_id
    FROM registrations
    WHERE id = registration_id_to_permit;   
    
    -- 권한 체크
    IF current_manager_id != auth.uid() then
        RAISE EXCEPTION 'only manager can handle permission';
    -- 변경할 record가 없는 경우
    ELSIF not found then
        RAISE EXCEPTION 'registration with id % does not exist', registration_id_to_permit;
    -- 동행 허용하는 경우 최대 인원수 초과하는지 확인
    ELSIF is_permitted_to_switch then
        SELECT count(1) 
        INTO current_permitted_head_count
        FROM registrations
        WHERE meeting_id = current_meeting_id and is_permitted = true;        
        SELECT head_count
        INTO max_head_count
        FROM meetings
        WHERE id = current_meeting_id;
        IF max_head_count <= current_permitted_head_count then
            RAISE EXCEPTION 'head count can not exceed %', max_head_count;
        END IF;
    END IF;
    
    -- 업데이트
    update public.registrations 
    set is_permitted = is_permitted_to_switch,
    updated_at = NOW()
    where id = registration_id_to_permit;
    
    -- 업데이트 결과 체크
    GET DIAGNOSTICS updated_count = ROW_COUNT;
    IF updated_count = 0 then
        RAISE EXCEPTION 'updated nothing';       
    ELSIF updated_count > 1 then
        RAISE EXCEPTION 'attempt to update % rows', updated_count;
    END IF;
END;
$$ LANGUAGE plpgsql;
```