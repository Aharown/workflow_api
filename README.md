# WORKFLOW API


## Overview

A Rails API that models an order lifecycle using a state machine, event tracking, and service objects to enforce clean domain boundaries (SoC).

This project demonstrates how production systems manage order state transitions safely and predictably.

This API allows clients to:
	•	Create orders
	•	View orders
	•	Transition orders through a lifecycle:
	•	confirm
	•	ship
	•	deliver
	•	cancel

Each transition is validated at the domain level (model level in Rails case) to prevent invalid state changes.

The architecture prioritises:
	•	State integrity
	•	Clear separation of concerns
	•	Explicit business processes

---

### Why a State Machine?
Orders in real systems move through defined stages.

For example:
pending → confirmed → shipped → delivered

Certain transitions must never be allowed:
	•	You cannot ship an order that hasn’t been confirmed.
	•	You cannot deliver an order that hasn’t been shipped.
	•	You cannot confirm a cancelled order.

A state machine enforces these rules explicitly.

Using AASM:
	•	Defines allowed transitions
	•	Prevents invalid transitions automatically
	•	Raises structured errors when violations occur
	•	Makes business rules visible and auditable

Without a state machine, state logic often becomes scattered across controllers and models, leading to fragile systems.

---

### Why Event Tracking?
Each transition represents a business event.

Example events:
	•	OrderConfirmed
	•	OrderShipped
	•	OrderDelivered
	•	OrderCancelled

Tracking events enables:
	•	Audit history
	•	Debugging state changes
	•	Analytics
	•	Future event-driven architecture
	•	Regulatory compliance

In production systems, every state change is traceable.

For example:
	•	Shopify tracks order fulfillment events.
	•	Delivery systems log package scan events.
	•	Payment processors log authorization and settlement events.

Event tracking creates observability and accountability.

---

### Why Services Instead of Fat Models?
Traditional Rails apps often place business logic directly inside models.

This can lead to:
	•	Bloated models
	•	Hard-to-test business logic
	•	Tight coupling between persistence and orchestration

Instead, this project uses service objects to represent business use cases.

Example:
Orders::TransitionService.call(order: order, event: :ship)

This approach:
	•	Keeps models responsible for domain rules (state machine + guards)
	•	Keeps controllers thin (HTTP only)
	•	Encapsulates business processes in reusable services
	•	Improves testability

This mirrors how larger systems structure application logic.

---

### Architectural Layers
Controller
→ Handles HTTP concerns
→ Calls services
→ Renders JSON

Service
→ Represents a business action
→ Calls domain methods
→ Coordinates logic

Model
→ Owns state machine
→ Enforces transition guards
→ Protects domain integrity

ApplicationController
→ Centralised error handling
→ Standardised API responses

This separation ensures:
	•	Clear responsibility boundaries
	•	Scalable architecture
	•	Easier refactoring


### Real-World Parallels
This architecture mirrors real production systems:

E-commerce (e.g. Shopify)

Orders move through defined states:
	•	Unfulfilled
	•	Fulfilled
	•	Cancelled

Transitions trigger side effects:
	•	Payment capture
	•	Inventory adjustment
	•	Email notifications

State transitions are validated centrally.

## Setup

### Requirements
	•	Ruby (3.x recommended)
	•	Rails (7.x recommended)
	•	PostgreSQL
	•	Bundler

### Installation
git clone https://github.com/Aharown/workflow_api
cd workflow_api
bundle install
rails db:create
rails db:migrate
rails s (http://localhost:3000)
