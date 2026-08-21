# Where logic goes

Decide the layer before writing code. Most bad Rails code is correct logic in
the wrong place.

**Naming: what the team's seminar and most Rails writing call a Service Object,
this repo calls an Operation, in `app/operations`. There is no `app/services`
and you must not create one.**

## Decision table

| The work is | Put it in | Do not |
| --- | --- | --- |
| A business workflow with several steps or several models | Operation (`app/operations`) | Grow the controller action, or bury the flow in a model callback |
| A complex or dynamic read: filters, sorting, dashboards, reports | Query object (`app/queries`) | Repeat the same ActiveRecord chain across controllers and views |
| Who may do what | Pundit policy (`app/policies`) | `if current_user.admin?` scattered through controllers and views |
| Whitelisting request attributes | `app/permit_params` class | Inline `params.permit` in the controller |
| A domain invariant that is always true of the record | Model validation | A rule only one form needs |
| Behaviour genuinely shared by several models or controllers | Concern | A concern used as a bin to make a class shorter |
| A small formatting detail in a view | Helper | Business rules in a helper |
| Presentation logic combining several sources | Presenter (`app/presenters`) | A controller assembling a pile of display state |
| Markup plus its own presentation behaviour, reused or worth testing alone | ViewComponent (`app/components`) | A large partial plus a helper that returns HTML |
| Several writes that must all succeed or all fail | Explicit transaction | Wrapping a single ordinary save |

## Operation or model?

An operation earns its place when there is a *workflow*: several writes, several
collaborators, or a sequence someone has to be able to read.

Line count is not the test. A long method about the record's own state belongs
on the model; a short method that coordinates three objects belongs in an
operation. Do not create an operation that only wraps `Model.create(...)` or
`model.update(...)`.

Name operations with verbs: `Users::Create`, not `Users::Creator`.

## Concern or operation?

- Concern — a module of *shared behaviour* mixed into several classes. Stateless.
  Soft deletion, sluggable, trackable.
- Operation — a class that performs *one action*. Holds its collaborators as
  state.

A concern that only one class includes is not shared behaviour; it is that
class's own code moved to a different file. Splitting a class to make it shorter
is not architecture.

## Views: helper, presenter, decorator, or component

Ask who owns the markup, and what the object is attached to.

| | Attached to | Owns markup | Use for |
| --- | --- | --- | --- |
| Helper | nothing | no | format a date, build a label or class string |
| Presenter | a page's worth of data | no | display state combined from several sources |
| Decorator | one record | no | display methods that read like model methods |
| ViewComponent | its own template | yes | markup with variants, worth its own spec |

A helper that starts building HTML, or a partial that grows conditionals around
its markup, is a component that has not been extracted yet. `FlashComponent` is
the worked example in this repo: type maps to colour and icon, the template
travels with the class, and `spec/components/flash_component_spec.rb` renders it
directly with `render_inline`.

## Layers this repo does not have

There is no `app/forms` and no `app/decorators`.

Form objects (validation serving one form, possibly spanning models) and
decorators (display methods bound to one record) are both reasonable patterns.
Introducing either here creates a convention for the whole team, so first check
whether an operation plus a model validation, or a presenter plus a component,
already covers the case. If you still need one, say explicitly that you are
introducing a new layer — do not do it quietly.

`app/permit_params` is the one that gets mistaken for a form layer, because it
is the only place a field list lives outside a model. It is not one. A
`<Resource>Params` class has no superclass, no validations, no `save`, no
coercion, and no branching on the actor — a permitted-attributes list is static
per resource. `app/permit_params/user_params.rb` is the whole pattern; read it
rather than elaborating on it.

## Two places the seminar deck will mislead you

The slides are a good map of the patterns, but two of their examples contradict
their own advice. Both were measured against this app on Rails 8.1.

**The Service Object example enqueues mail inside the transaction.** Slide 3
shows `OrderMailer.confirmation(order).deliver_later` inside
`ActiveRecord::Base.transaction`, while slide 14 tells you not to put non-DB code
in a transaction. Slide 14 is right; see `.claude/rules/rails-transactions.md`
for what actually happens and how to fix it.

**The Query Object example's `return self` does not transplant.** Slide 9 works
because `relation.extending(Filterable)` mixes the module into the relation, so
inside `filter_by_food_type` `self` *is* the relation and `where` is the
relation's method. Copying that shape into a method on a query object breaks:
`self` becomes the query object, which has no `where`. That is exactly how
`Users::Gather` came to raise `ArgumentError` on every non-blank email — it had
no caller and no spec, so nothing noticed.

This repo's `ApplicationQuery` is not the one on the slide. It has no
`query_on`, `relation`, or `options`. It gives you `call(scope = Model.all,
**params)` plus `filter(scope, :method, value)` and `sort(scope, value)`, and
your filter methods take `(scope, value)` and return a relation.

## Before adding any abstraction

Search for the existing equivalent first. This codebase already has an answer
for most shapes of work, and a second parallel pattern costs more than the
duplication it removes.
