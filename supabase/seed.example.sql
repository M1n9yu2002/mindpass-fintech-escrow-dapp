-- MindPass demo seed data
-- Fake local/demo data only. Do not replace these rows with real user data in git.

INSERT INTO public.patients (
  wallet_address,
  username,
  total_deposits,
  support_code,
  subsidy_balance
) VALUES (
  '0x0000000000000000000000000000000000000001',
  'demo_patient',
  0,
  'DEMO-SUPPORT',
  0.005
) ON CONFLICT (wallet_address) DO NOTHING;

INSERT INTO public.therapists (
  wallet_address,
  full_name,
  work_email,
  specialty,
  bio,
  languages,
  ekyc_status,
  sbt_minted,
  is_online,
  supported_modes,
  legal_name,
  clinical_specialty
) VALUES (
  '0x0000000000000000000000000000000000000002',
  'Demo Provider',
  NULL,
  'Digital Services',
  'Demo provider profile for local portfolio testing only.',
  ARRAY['English'],
  'verified',
  false,
  true,
  ARRAY['text', 'voice'],
  NULL,
  'Digital Services'
) ON CONFLICT (wallet_address) DO NOTHING;

INSERT INTO public.redeem_codes (
  code,
  eth_value,
  is_used,
  used_by_wallet,
  used_by_username,
  used_at
) VALUES (
  'DEMO-CODE-001',
  0.005,
  false,
  NULL,
  NULL,
  NULL
) ON CONFLICT (code) DO NOTHING;

INSERT INTO public.sessions (
  patient_wallet,
  therapist_wallet,
  status,
  escrow_amount,
  amount_eth,
  session_mode,
  session_fee_eth,
  funding_source,
  subsidy_applied_eth,
  wallet_required_eth,
  wallet_funded_eth,
  patient_subsidy_choice_eth,
  patient_wallet_choice_eth,
  settlement_status,
  chain_id
) VALUES (
  '0x0000000000000000000000000000000000000001',
  '0x0000000000000000000000000000000000000002',
  'requested',
  0.005,
  0.005,
  'text',
  0.005,
  'mixed',
  0.002,
  0.003,
  0,
  0.002,
  0.003,
  'pending',
  11155111
);
