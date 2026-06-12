# Limitations and Future Work

MindPass is an MVP and public portfolio prototype. It demonstrates a hybrid FinTech DApp architecture for programmable escrow, subsidy-aware funding, and verifiable settlement in appointment-based digital services.

It is not production-ready and should not be presented as a complete healthcare, counselling, clinical-record, or compliance platform.

## Current Limitations

- Timeout and no-show resolution are currently user/service-triggered, not fully autonomous.
- Supabase mirror state may become inconsistent if transaction receipt decoding or event syncing fails.
- There is no full event indexer.
- There is no replay-safe or reorg-safe sync worker.
- RLS and Supabase policies are demo-level and require a full security pass before production use.
- Provider verification is application-level only and does not represent real licensing verification.
- The escrow contract uses fixed demo fee constants and short timing windows.
- Server-side subsidy funding depends on a prototype vault/private-key relayer model.
- Operational concerns such as monitoring, alerting, key rotation, incident response, and audit trails are not complete.

## Outside the Implemented MVP Scope

The following are not implemented in this MVP:

- encrypted clinical record storage
- IPFS-based clinical storage
- decentralised identity
- SBT credentialing
- secure messaging
- real therapist licensing
- production healthcare compliance
- privacy-preserving medical-record management

Any public description of the project should frame these as future possibilities or excluded scope, not as completed features.

## Future Work

- Add automated timeout and no-show resolution through a backend worker, keeper, or relayer service.
- Build a replay-safe contract event indexer with block tracking, retries, and reorg handling.
- Expand Hardhat tests for payment timeout, patient no-show, provider no-show, mixed refund splits, unauthorized callers, duplicate funding, duplicate check-in, pause behavior, and withdrawal balance reset.
- Replace demo RLS with strict wallet-aware access policies.
- Add private storage rules if attachment uploads remain part of the demo.
- Add event-sync observability and reconciliation tooling.
- Document deployment environments and key-management expectations.
- Run a production security review before any real funds, real users, private data, or regulated workflow is introduced.
