-- MindPass Supabase public schema
-- This file contains the public database schema used by the MindPass MVP.
-- It is provided for portfolio and reproducibility purposes only.
-- No production data, user records, private keys, or Supabase secrets are included.

CREATE TABLE public.activities (
  id uuid DEFAULT gen_random_uuid() NOT NULL,
  wallet_address text NOT NULL,
  title text NOT NULL,
  description text,
  status text DEFAULT 'Completed'::text,
  created_at timestamp with time zone DEFAULT timezone('utc'::text, now())
);

CREATE TABLE public.chat_attachments (
  id uuid DEFAULT gen_random_uuid() NOT NULL,
  message_id uuid NOT NULL,
  session_id uuid NOT NULL,
  uploader_wallet text NOT NULL,
  mime_type text NOT NULL,
  original_filename text,
  storage_bucket text DEFAULT 'chat-attachments'::text NOT NULL,
  storage_path text NOT NULL,
  byte_size bigint DEFAULT 0 NOT NULL,
  patient_download_allowed boolean DEFAULT true NOT NULL,
  therapist_view_allowed boolean DEFAULT true NOT NULL,
  therapist_download_allowed boolean DEFAULT false NOT NULL,
  therapist_view_expires_at timestamp with time zone,
  created_at timestamp with time zone DEFAULT now() NOT NULL
);

CREATE TABLE public.chat_messages (
  id uuid DEFAULT gen_random_uuid() NOT NULL,
  session_id uuid NOT NULL,
  sender_wallet text NOT NULL,
  sender_role text NOT NULL,
  message_type text DEFAULT 'text'::text NOT NULL,
  content text,
  metadata jsonb DEFAULT '{}'::jsonb NOT NULL,
  is_deleted boolean DEFAULT false NOT NULL,
  created_at timestamp with time zone DEFAULT now() NOT NULL,
  updated_at timestamp with time zone DEFAULT now() NOT NULL
);

CREATE TABLE public.patients (
  id uuid DEFAULT gen_random_uuid() NOT NULL,
  wallet_address text NOT NULL,
  username text,
  total_deposits numeric DEFAULT 0,
  created_at timestamp with time zone DEFAULT timezone('utc'::text, now()),
  support_code text,
  subsidy_balance numeric DEFAULT 0
);

CREATE TABLE public.redeem_codes (
  id uuid DEFAULT gen_random_uuid() NOT NULL,
  code text NOT NULL,
  eth_value numeric DEFAULT 0.005,
  is_used boolean DEFAULT false,
  used_by_wallet text,
  used_by_username text,
  used_at timestamp with time zone
);

CREATE TABLE public.session_end_requests (
  id uuid DEFAULT gen_random_uuid() NOT NULL,
  session_id uuid NOT NULL,
  requested_by_wallet text NOT NULL,
  requested_by_role text NOT NULL,
  target_wallet text NOT NULL,
  target_role text NOT NULL,
  status text DEFAULT 'pending'::text NOT NULL,
  requester_confirmed_at timestamp with time zone DEFAULT now() NOT NULL,
  target_responded_at timestamp with time zone,
  accepted_at timestamp with time zone,
  declined_at timestamp with time zone,
  cancelled_at timestamp with time zone,
  expired_at timestamp with time zone,
  target_response_text text,
  requester_note text,
  created_at timestamp with time zone DEFAULT now() NOT NULL,
  updated_at timestamp with time zone DEFAULT now() NOT NULL,
  receiver_seen_at timestamp with time zone,
  modal_presented_at timestamp with time zone,
  notification_sent_at timestamp with time zone
);

CREATE TABLE public.sessions (
  id uuid DEFAULT gen_random_uuid() NOT NULL,
  patient_wallet text,
  therapist_wallet text,
  status text DEFAULT 'requested'::text,
  escrow_amount numeric DEFAULT 0.005,
  created_at timestamp with time zone DEFAULT timezone('utc'::text, now()),
  updated_at timestamp with time zone DEFAULT timezone('utc'::text, now()),
  amount_eth double precision DEFAULT 0.005,
  session_mode text DEFAULT 'text'::text,
  session_fee_eth numeric DEFAULT 0.005,
  funding_source text,
  subsidy_applied_eth numeric DEFAULT 0,
  wallet_required_eth numeric DEFAULT 0,
  wallet_funded_eth numeric DEFAULT 0,
  protocol_fee_eth numeric DEFAULT 0,
  therapist_payout_eth numeric DEFAULT 0,
  scheduled_start_at timestamp with time zone,
  scheduled_end_at timestamp with time zone,
  therapist_responded_at timestamp with time zone,
  patient_confirmed_at timestamp with time zone,
  patient_cancelled_at timestamp with time zone,
  rejection_reason text,
  patient_subsidy_choice_eth numeric DEFAULT 0,
  patient_wallet_choice_eth numeric DEFAULT 0,
  ack_penalty_policy boolean DEFAULT false,
  ack_illegal_policy boolean DEFAULT false,
  ack_single_active_booking boolean DEFAULT false,
  provider_accepted_at timestamp with time zone,
  payment_due_at timestamp with time zone,
  patient_paid_at timestamp with time zone,
  funded_at timestamp with time zone,
  patient_joined_at timestamp with time zone,
  therapist_joined_at timestamp with time zone,
  session_started_at timestamp with time zone,
  completed_at timestamp with time zone,
  rejected_at timestamp with time zone,
  payment_timeout_at timestamp with time zone,
  no_show_deadline_at timestamp with time zone,
  penalty_fee_eth numeric DEFAULT 0,
  refund_amount_eth numeric DEFAULT 0,
  settlement_status text DEFAULT 'pending'::text,
  onchain_session_id bigint,
  contract_address text,
  chain_id bigint DEFAULT 11155111,
  booking_tx_hash text,
  accept_tx_hash text,
  patient_fund_tx_hash text,
  subsidy_fund_tx_hash text,
  patient_checkin_tx_hash text,
  therapist_checkin_tx_hash text,
  complete_tx_hash text,
  resolve_tx_hash text,
  cancel_tx_hash text,
  withdraw_tx_hash text,
  subsidy_funded_eth numeric(36,18) DEFAULT 0 NOT NULL,
  patient_refund_eth numeric(36,18) DEFAULT 0 NOT NULL,
  vault_refund_eth numeric(36,18) DEFAULT 0 NOT NULL,
  total_refund_eth numeric(36,18) DEFAULT 0 NOT NULL,
  cancelled_unstarted_at timestamp with time zone,
  cancelled_by_wallet text,
  cancellation_reason text,
  settlement_source text DEFAULT 'database'::text,
  last_onchain_event text,
  last_synced_block bigint,
  last_synced_log_index integer,
  sync_error text,
  create_booking_tx_hash text,
  accept_booking_tx_hash text,
  reject_booking_tx_hash text,
  fund_patient_tx_hash text,
  fund_subsidy_tx_hash text,
  cancel_unstarted_tx_hash text,
  session_started_tx_hash text,
  complete_session_tx_hash text,
  resolve_payment_timeout_tx_hash text,
  resolve_no_show_tx_hash text,
  patient_withdrawal_tx_hash text,
  therapist_withdrawal_tx_hash text,
  vault_withdrawal_tx_hash text,
  protocol_withdrawal_tx_hash text,
  last_synced_tx_hash text,
  last_synced_at timestamp with time zone,
  chat_opened_at timestamp with time zone,
  last_message_at timestamp with time zone,
  message_count integer DEFAULT 0 NOT NULL,
  active_end_request_id uuid,
  queue_entered_at timestamp with time zone,
  estimated_ready_at timestamp with time zone,
  queue_position integer,
  patient_cancelled_waiting_at timestamp with time zone,
  subsidy_refunded_eth numeric(18,18) DEFAULT 0 NOT NULL
);

CREATE TABLE public.support_requests (
  id uuid DEFAULT gen_random_uuid() NOT NULL,
  session_id uuid,
  reporter_wallet text NOT NULL,
  reporter_role text NOT NULL,
  issue_type text NOT NULL,
  message text,
  status text DEFAULT 'open'::text NOT NULL,
  created_at timestamp with time zone DEFAULT now() NOT NULL
);

CREATE TABLE public.therapist_auth_logs (
  id uuid DEFAULT gen_random_uuid() NOT NULL,
  therapist_wallet text NOT NULL,
  action text NOT NULL,
  user_agent text,
  created_at timestamp with time zone DEFAULT timezone('utc'::text, now()) NOT NULL
);

CREATE TABLE public.therapists (
  id uuid DEFAULT gen_random_uuid() NOT NULL,
  wallet_address text NOT NULL,
  full_name text,
  work_email text,
  specialty text,
  bio text,
  languages text[],
  ekyc_status text DEFAULT 'verified'::text,
  sbt_minted boolean DEFAULT false,
  is_online boolean DEFAULT false,
  rating numeric DEFAULT 5.0,
  total_sessions integer DEFAULT 0,
  total_earned_eth numeric DEFAULT 0,
  created_at timestamp with time zone DEFAULT timezone('utc'::text, now()),
  supported_modes text[] DEFAULT ARRAY[]::text[],
  legal_name text,
  resume_url text,
  license_url text,
  id_card_url text,
  sbt_status text DEFAULT 'pending'::text,
  ekyc_score double precision,
  clinical_specialty text,
  selfie_url text,
  no_show_flag_count integer DEFAULT 0 NOT NULL,
  mutual_unstarted_flag_count integer DEFAULT 0 NOT NULL
);

ALTER TABLE ONLY public.activities ADD CONSTRAINT activities_pkey PRIMARY KEY (id);

ALTER TABLE ONLY public.chat_attachments ADD CONSTRAINT chat_attachments_byte_size_check CHECK ((byte_size >= 0));

ALTER TABLE ONLY public.chat_attachments ADD CONSTRAINT chat_attachments_message_id_fkey FOREIGN KEY (message_id) REFERENCES chat_messages(id) ON DELETE CASCADE;

ALTER TABLE ONLY public.chat_attachments ADD CONSTRAINT chat_attachments_pkey PRIMARY KEY (id);

ALTER TABLE ONLY public.chat_attachments ADD CONSTRAINT chat_attachments_session_id_fkey FOREIGN KEY (session_id) REFERENCES sessions(id) ON DELETE CASCADE;

ALTER TABLE ONLY public.chat_messages ADD CONSTRAINT chat_messages_content_required CHECK ((((message_type = ANY (ARRAY['text'::text, 'system'::text])) AND (content IS NOT NULL)) OR (message_type = 'attachment'::text)));

ALTER TABLE ONLY public.chat_messages ADD CONSTRAINT chat_messages_message_type_check CHECK ((message_type = ANY (ARRAY['text'::text, 'system'::text, 'attachment'::text])));

ALTER TABLE ONLY public.chat_messages ADD CONSTRAINT chat_messages_pkey PRIMARY KEY (id);

ALTER TABLE ONLY public.chat_messages ADD CONSTRAINT chat_messages_sender_role_check CHECK ((sender_role = ANY (ARRAY['patient'::text, 'therapist'::text, 'system'::text])));

ALTER TABLE ONLY public.chat_messages ADD CONSTRAINT chat_messages_session_id_fkey FOREIGN KEY (session_id) REFERENCES sessions(id) ON DELETE CASCADE;

ALTER TABLE ONLY public.patients ADD CONSTRAINT patients_pkey PRIMARY KEY (id);

ALTER TABLE ONLY public.patients ADD CONSTRAINT patients_wallet_address_key UNIQUE (wallet_address);

ALTER TABLE ONLY public.patients ADD CONSTRAINT patients_wallet_address_key1 UNIQUE (wallet_address);

ALTER TABLE ONLY public.redeem_codes ADD CONSTRAINT redeem_codes_code_key UNIQUE (code);

ALTER TABLE ONLY public.redeem_codes ADD CONSTRAINT redeem_codes_pkey PRIMARY KEY (id);

ALTER TABLE ONLY public.session_end_requests ADD CONSTRAINT session_end_requests_pkey PRIMARY KEY (id);

ALTER TABLE ONLY public.session_end_requests ADD CONSTRAINT session_end_requests_requested_by_role_check CHECK ((requested_by_role = ANY (ARRAY['patient'::text, 'therapist'::text])));

ALTER TABLE ONLY public.session_end_requests ADD CONSTRAINT session_end_requests_session_id_fkey FOREIGN KEY (session_id) REFERENCES sessions(id) ON DELETE CASCADE;

ALTER TABLE ONLY public.session_end_requests ADD CONSTRAINT session_end_requests_status_check CHECK ((status = ANY (ARRAY['pending'::text, 'accepted'::text, 'declined'::text, 'cancelled'::text, 'expired'::text])));

ALTER TABLE ONLY public.session_end_requests ADD CONSTRAINT session_end_requests_target_role_check CHECK ((target_role = ANY (ARRAY['patient'::text, 'therapist'::text])));

ALTER TABLE ONLY public.sessions ADD CONSTRAINT sessions_fee_breakdown_chk CHECK (((abs(((COALESCE(patient_subsidy_choice_eth, (0)::numeric) + COALESCE(patient_wallet_choice_eth, (0)::numeric)) - COALESCE(session_fee_eth, 0.005))) <= 0.000001) AND (abs(((COALESCE(subsidy_applied_eth, (0)::numeric) + COALESCE(wallet_required_eth, (0)::numeric)) - COALESCE(session_fee_eth, 0.005))) <= 0.000001) AND (COALESCE(escrow_amount, (0)::numeric) = COALESCE(session_fee_eth, 0.005)) AND (COALESCE(patient_subsidy_choice_eth, (0)::numeric) >= (0)::numeric) AND (COALESCE(patient_wallet_choice_eth, (0)::numeric) >= (0)::numeric) AND (COALESCE(subsidy_applied_eth, (0)::numeric) >= (0)::numeric) AND (COALESCE(wallet_required_eth, (0)::numeric) >= (0)::numeric) AND (COALESCE(wallet_funded_eth, (0)::numeric) >= (0)::numeric) AND (COALESCE(protocol_fee_eth, (0)::numeric) >= (0)::numeric) AND (COALESCE(therapist_payout_eth, (0)::numeric) >= (0)::numeric) AND (COALESCE(penalty_fee_eth, (0)::numeric) >= (0)::numeric) AND (COALESCE(refund_amount_eth, (0)::numeric) >= (0)::numeric))) NOT VALID;

ALTER TABLE ONLY public.sessions ADD CONSTRAINT sessions_funding_source_chk CHECK ((funding_source = ANY (ARRAY['subsidy'::text, 'mixed'::text, 'wallet'::text]))) NOT VALID;

ALTER TABLE ONLY public.sessions ADD CONSTRAINT sessions_onchain_session_id_key UNIQUE (onchain_session_id);

ALTER TABLE ONLY public.sessions ADD CONSTRAINT sessions_patient_wallet_fkey FOREIGN KEY (patient_wallet) REFERENCES patients(wallet_address);

ALTER TABLE ONLY public.sessions ADD CONSTRAINT sessions_pkey PRIMARY KEY (id);

ALTER TABLE ONLY public.sessions ADD CONSTRAINT sessions_settlement_status_chk CHECK (((settlement_status IS NULL) OR (settlement_status = ANY (ARRAY['pending'::text, 'awaiting_patient_payment'::text, 'held_in_escrow'::text, 'released_to_therapist'::text, 'cancelled'::text, 'penalty_paid_to_therapist'::text, 'refunded_to_patient'::text, 'refunded_to_vault'::text, 'refunded_split_patient_vault'::text, 'mutual_unstarted_platform_fee'::text]))));

ALTER TABLE ONLY public.sessions ADD CONSTRAINT sessions_status_chk CHECK ((status = ANY (ARRAY['requested'::text, 'accepted_awaiting_payment'::text, 'funded'::text, 'in_session'::text, 'completed'::text, 'rejected'::text, 'payment_timeout'::text, 'patient_no_show'::text, 'therapist_no_show'::text, 'queued_waiting_for_provider'::text, 'patient_cancelled_waiting'::text, 'mutual_unstarted'::text])));

ALTER TABLE ONLY public.sessions ADD CONSTRAINT sessions_therapist_wallet_fkey FOREIGN KEY (therapist_wallet) REFERENCES therapists(wallet_address);

ALTER TABLE ONLY public.support_requests ADD CONSTRAINT support_requests_pkey PRIMARY KEY (id);

ALTER TABLE ONLY public.support_requests ADD CONSTRAINT support_requests_reporter_role_check CHECK ((reporter_role = ANY (ARRAY['patient'::text, 'therapist'::text])));

ALTER TABLE ONLY public.support_requests ADD CONSTRAINT support_requests_session_id_fkey FOREIGN KEY (session_id) REFERENCES sessions(id) ON DELETE SET NULL;

ALTER TABLE ONLY public.therapist_auth_logs ADD CONSTRAINT therapist_auth_logs_action_check CHECK ((action = ANY (ARRAY['login'::text, 'logout'::text, 'session_expired'::text])));

ALTER TABLE ONLY public.therapist_auth_logs ADD CONSTRAINT therapist_auth_logs_pkey PRIMARY KEY (id);

ALTER TABLE ONLY public.therapists ADD CONSTRAINT therapists_pkey PRIMARY KEY (id);

ALTER TABLE ONLY public.therapists ADD CONSTRAINT therapists_supported_modes_check CHECK ((supported_modes <@ ARRAY['text'::text, 'voice'::text]));

ALTER TABLE ONLY public.therapists ADD CONSTRAINT therapists_wallet_address_key UNIQUE (wallet_address);

CREATE INDEX chat_attachments_message_idx ON public.chat_attachments USING btree (message_id);

CREATE INDEX chat_attachments_session_idx ON public.chat_attachments USING btree (session_id, created_at);

CREATE INDEX chat_messages_sender_wallet_idx ON public.chat_messages USING btree (sender_wallet);

CREATE INDEX chat_messages_session_created_idx ON public.chat_messages USING btree (session_id, created_at);

CREATE INDEX chat_messages_session_desc_idx ON public.chat_messages USING btree (session_id, created_at DESC);

CREATE UNIQUE INDEX patients_wallet_address_lower_uidx ON public.patients USING btree (lower(wallet_address));

CREATE UNIQUE INDEX redeem_codes_code_lower_uidx ON public.redeem_codes USING btree (lower(code));

CREATE INDEX session_end_requests_requester_idx ON public.session_end_requests USING btree (requested_by_wallet, status, created_at DESC);

CREATE INDEX session_end_requests_session_idx ON public.session_end_requests USING btree (session_id, created_at DESC);

CREATE INDEX session_end_requests_target_idx ON public.session_end_requests USING btree (target_wallet, status, created_at DESC);

CREATE INDEX session_end_requests_target_unread_idx ON public.session_end_requests USING btree (target_wallet, status, receiver_seen_at, created_at DESC);

CREATE UNIQUE INDEX session_end_requests_one_pending_per_session_idx ON public.session_end_requests USING btree (session_id) WHERE (status = 'pending'::text);

CREATE INDEX idx_sessions_open_by_patient ON public.sessions USING btree (lower(patient_wallet), status, created_at DESC) WHERE (status = ANY (ARRAY['requested'::text, 'accepted_awaiting_payment'::text, 'funded'::text, 'in_session'::text]));

CREATE INDEX idx_sessions_open_by_therapist ON public.sessions USING btree (lower(therapist_wallet), status, created_at DESC) WHERE (status = ANY (ARRAY['requested'::text, 'accepted_awaiting_payment'::text, 'funded'::text, 'in_session'::text]));

CREATE INDEX idx_sessions_patient_wallet ON public.sessions USING btree (patient_wallet);

CREATE INDEX idx_sessions_status ON public.sessions USING btree (status);

CREATE INDEX idx_sessions_therapist_wallet ON public.sessions USING btree (therapist_wallet);

CREATE INDEX sessions_chain_contract_idx ON public.sessions USING btree (chain_id, contract_address);

CREATE INDEX sessions_estimated_ready_idx ON public.sessions USING btree (estimated_ready_at);

CREATE INDEX sessions_last_onchain_event_idx ON public.sessions USING btree (last_onchain_event);

CREATE INDEX sessions_onchain_session_id_idx ON public.sessions USING btree (onchain_session_id);

CREATE INDEX sessions_patient_wait_queue_idx ON public.sessions USING btree (patient_wallet, status, queue_entered_at DESC);

CREATE INDEX sessions_provider_wait_queue_idx ON public.sessions USING btree (therapist_wallet, status, queue_position, queue_entered_at);

CREATE INDEX sessions_therapist_queue_idx ON public.sessions USING btree (therapist_wallet, status, queue_entered_at);

CREATE UNIQUE INDEX uniq_open_session_per_patient ON public.sessions USING btree (lower(patient_wallet)) WHERE (status = ANY (ARRAY['requested'::text, 'accepted_awaiting_payment'::text, 'funded'::text, 'in_session'::text]));

CREATE INDEX support_requests_reporter_idx ON public.support_requests USING btree (reporter_wallet, created_at DESC);

CREATE INDEX support_requests_session_idx ON public.support_requests USING btree (session_id, created_at DESC);

CREATE INDEX idx_therapist_auth_logs_wallet ON public.therapist_auth_logs USING btree (therapist_wallet);

CREATE INDEX therapist_auth_logs_wallet_created_at_idx ON public.therapist_auth_logs USING btree (therapist_wallet, created_at DESC);

CREATE UNIQUE INDEX therapists_wallet_address_lower_uidx ON public.therapists USING btree (lower(wallet_address));

ALTER TABLE public.therapists ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Enable insert for all users" ON public.therapists AS PERMISSIVE FOR INSERT TO public WITH CHECK (true);

CREATE POLICY "Enable read access for all users" ON public.therapists AS PERMISSIVE FOR SELECT TO public USING (true);

CREATE POLICY "Enable update for all users" ON public.therapists AS PERMISSIVE FOR UPDATE TO public USING (true);
