--- @title 风卷浪
--- @author 神鹰(455168247@qq.com)
--- @date 2018-2-23 00:34:32

local m = 32828002
local cm = _G["c" .. m]
function cm.initial_effect(c)
    local e1 = Effect.CreateEffect(c)
    e1:SetCategory(CATEGORY_TODECK)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetHintTiming(0, TIMING_END_PHASE)
    e1:SetCost(cm.cost)
    e1:SetTarget(cm.target)
    e1:SetOperation(cm.activate)
    c:RegisterEffect(e1)
end

function cm.cost(e, tp, eg, ep, ev, re, r, rp, chk)
    local c = e:GetHandler()
    if chk == 0 then
        return Duel.IsExistingMatchingCard(nil, tp, LOCATION_ONFIELD, 0, 1, c)
    end
    Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_RTOHAND)
    local g = Duel.SelectMatchingCard(tp, nil, tp, LOCATION_ONFIELD, 0, 1, 1, c)
    Duel.SendtoHand(g, nil, REASON_COST)
end

function cm.target(e, tp, eg, ep, ev, re, r, rp, chk)
    if chk == 0 then return Duel.IsExistingMatchingCard(Card.IsAbleToDeck, tp, LOCATION_ONFIELD, LOCATION_ONFIELD, 1, e:GetHandler()) end
    local g = Duel.GetMatchingGroup(Card.IsAbleToDeck, tp, LOCATION_ONFIELD, LOCATION_ONFIELD, e:GetHandler())
    Duel.SetOperationInfo(0, CATEGORY_TODECK, g, 1, 0, 0)
end

function cm.activate(e, tp, eg, ep, ev, re, r, rp)
    Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_TODECK)
    local g = Duel.SelectMatchingCard(tp, Card.IsAbleToDeck, tp, LOCATION_ONFIELD, LOCATION_ONFIELD, 1, 1, e:GetHandler())
    if g:GetCount() > 0 then
        Duel.HintSelection(g)
        Duel.SendtoDeck(g, nil, 2, REASON_EFFECT)
    end
end
