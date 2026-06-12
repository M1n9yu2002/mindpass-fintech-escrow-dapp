# Supabase

This folder contains the public Supabase reference files for the MindPass demo MVP.

## Files

- `schema.sql` defines the public demo schema used by the current frontend and settlement mirror.
- `seed.example.sql` contains fake local/demo rows only.

No production data, real user records, private keys, real transaction hashes, uploaded document paths, or real support messages are included.

## Scope

The schema is intended for portfolio reproducibility and local demo setup. It mirrors the current MVP data model for:

- patient/customer wallet records
- provider records
- booking/session lifecycle state
- funding split and settlement fields
- on-chain session ids, contract addresses, chain ids, and transaction hashes
- chat/support tables used by the prototype UI

## RLS and Policy Warning

The current RLS/policy setup is demo-level and not production-ready.

At the moment, `therapists` has permissive public policies suitable only for prototype testing. A production deployment would require:

- wallet-aware access control for patient/customer and provider rows
- strict row-level policies for sessions, messages, attachments, support requests, and audit logs
- private storage bucket policies for uploads
- service-role-only sync paths for contract event mirroring
- audited policies for all inserts, updates, and realtime subscriptions
- a clear separation between public demo data and private operational data

Do not use this schema as-is for production.

## Schema Reconciliation Notes

The public schema includes nullable `patients.username` and `redeem_codes.used_by_username` columns because current API routes reference them.

Some application code still contains compatibility fallbacks for historical redeem-code amount field names. Before productionizing the database, reconcile those aliases into one canonical column and update the API code accordingly.
