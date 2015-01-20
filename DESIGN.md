# Hack

## Models

### Topic

- Topic is where incidents are notified from. (e.g. Mailgun Route, Waker API)

#### Fields

- `name`
- `type` (one of `mailgun` and `api`)
- `escalation_series`

### User

- User is a person who will receive notification.
- User has many notifiers

#### Fields

- `name`

### Notifier

- Notifier is where notifications are sent to. (e.g. Mail, Phone, HTTP endpoint, HipChat)
- Notification types are:
  - incident\_opened
  - incident\_acknowledged
  - incident\_resolved
  - incident\_escalated

#### Fields

- `type`
- `settings` (JSON)
- `notify_after_sec`

### Shift

#### Fields

- `current_user`

### Escalation

#### Fields

- `escalate_to` (Shift)
- `escalate_after_sec`

### EscalationSeries

#### Fields

- `escalations` (Escalation)

### IncidentAction

#### Fields

- `incident`
- `kind_of_action`: `opened`, `acknowledged`, `resolved`, `escalated`, `comment`
- `text`
- `user_by`: can be nil

