--!strict

local Meta = require('@lorry.utils/lib/Meta')
local Wrapper = require('@lorry.project/lib/Wrapper')
local Selector = require('./Selector')

local Subscription = {
  Selector = Selector,
}

export type Subscription = typeof(Subscription) & Wrapper.Unwrappable<Unwrapped>

export type SubscriptionProps = {
  socket_name: string,
  selectors: {Selector.Selector},
}

export type UnwrappedSubscription = {
  socket_name: string
}

export type Unwrapped = {
  subscription: UnwrappedSubscription,
  selectors: {Selector.Unwrapped},
}

export type SubscriptionImpl = Subscription & SubscriptionProps

export type AnyChild =
  | Selector.Selector

function Subscription:new(o: SubscriptionProps): Subscription
  return Meta:type(o, self, "Transport.Subscription")
end

function Subscription:from(socket_name: string): Subscription
  return Subscription:new({
    socket_name = socket_name,
    selectors = Meta:array {},
  })
end

function Subscription:setup(children: {AnyChild}): Subscription
  local this = self::SubscriptionImpl
  for _, child in children do
    this:with_child(child)
  end
  return this
end

function Subscription:with_child(child: AnyChild): Subscription
  local this = self::SubscriptionImpl
  local tag = Meta:typeof(child)
  if tag == 'Transport.Selector' then
    this.selectors[#this.selectors + 1] = child::Selector.Selector
  end
  return this
end

function Subscription:unwrap_subscription(): UnwrappedSubscription
  return {
    socket_name = self.socket_name,
  }
end

function Subscription:unwrap(): Unwrapped
  local this = self::SubscriptionImpl
  return {
    subscription = this:unwrap_subscription(),
    selectors = Wrapper:unwrap_array(this.selectors),
  }
end

return Subscription
