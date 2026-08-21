---
name: create-controller
description: Expose an existing model over HTTP — route, controller, Pundit policy, permit_params class, views and specs, wired the way this app already does it. Use when the model exists and the task is adding or extending an endpoint or CRUD screen.
---

Endpoint: $ARGUMENTS

A controller here is never one file. If the model does not exist yet either,
this is a multi-layer feature — use `implement-feature` instead.

## 1. Decide the shape before writing anything

Three decisions, in this order:

**Which base?** `Admin::BaseController` for anything behind the admin gate — it
sets `layout 'admin'`, calls `authenticate_admin!`, and overrides `authorize` /
`policy_scope` to namespace into `[:admin, record]`, so call the plain methods
and let it do the namespacing. `ApplicationController` otherwise. Devise
subclasses live under `Authentication::`.

**`Crudable` or explicit actions?** A standard CRUD screen over one model is
`include Crudable` plus a `crud_to` declaration —
`app/controllers/admin/users_controller.rb` is the whole worked example and is
19 lines. Anything that is not seven-actions-over-one-model writes its actions
out; `Admin::DashboardController` is that shape.

**Which route file?** `config/routes.rb` only draws `system`, `user` and
`admin`; the resource lines live in `config/routes/*.rb`. Add to the matching
one rather than to `routes.rb`.

## 2. The files that move together

| Layer | Where |
| --- | --- |
| route | `config/routes/{admin,user,system}.rb` |
| controller | `app/controllers/...` |
| policy | `app/policies/` — admin ones under `app/policies/admin`, inheriting `Admin::BasePolicy` |
| strong params | `app/permit_params/x_params.rb`, exposing `permitted_attributes`; the controller's `resource_permitted_params` calls it |
| query / operation | a filtered or sorted index needs a query; any mutation beyond `crud_to`'s default belongs in an operation |
| views | `app/views/...`, Slim |
| specs | a policy spec plus a system spec. Neither `spec/requests` nor `spec/policies` exists yet — create the directory, RSpec infers the type from the path |

Skipping the policy is the failure that matters. `authorize` raising because a
policy is missing is loud; a `policy_scope` that was never called is silent.

## 3. Constraints

`.claude/rules/controllers.md` auto-loads when you open a controller and holds
the full set — what `ApplicationController` already provides and must not be
re-added, `send_flash_message`, `only_turbo_stream_for`, Turbo semantics. Two
that specifically catch new endpoints:

- **Ordering.** `Crudable#index` hands the collection straight to Pagy without
  adding an order, and no model sets `implicit_order_column` while primary keys
  are random UUIDv4. An index action whose order matters must order explicitly,
  or page 2 will repeat one row and drop another.
- **Flashes.** The application layout does not render them; only the `devise`
  and `admin` layouts do. A flash set on a page using the application layout is
  invisible.

## 4. Verify

The Stop hook already runs RuboCop and `zeitwerk:check`. Yours to run and
paste:

- `bin/rails routes -g <resource>` — the route exists with the path you expect
- `bin/rspec` on the specs you wrote (`spec/policies/...`, `spec/system/...`)
- for anything touching admin, auth or permissions, dispatch `reviewer-agent`
  (read-only, Security section) over the diff

Report the files added, the authorization rule you implemented, and the
commands you ran.
