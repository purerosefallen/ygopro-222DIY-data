--高垣枫
function c81010016.initial_effect(c)
    --xyz summon
    aux.AddXyzProcedure(c,nil,8,2,c81010016.ovfilter,aux.Stringid(81010016,0))
    c:EnableReviveLimit()
    --battle
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
    e1:SetCode(EVENT_BATTLED)
    e1:SetOperation(c81010016.baop)
    c:RegisterEffect(e1)
    --destroy
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(81010016,0))
    e2:SetCategory(CATEGORY_DESTROY+CATEGORY_DECKDES)
    e2:SetType(EFFECT_TYPE_IGNITION)
    e2:SetRange(LOCATION_MZONE)
    e2:SetCountLimit(1,81010016)
    e2:SetCost(c81010016.cost)
    e2:SetTarget(c81010016.target)
    e2:SetOperation(c81010016.operation)
    c:RegisterEffect(e2)
end
function c81010016.ovfilter(c)
    return c:IsFaceup() and c:IsType(TYPE_MONSTER) and c:IsType(TYPE_LINK)
end
function c81010016.baop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local d=c:GetBattleTarget()
    if d and c:IsFaceup() and not c:IsStatus(STATUS_DESTROY_CONFIRMED) and d:IsStatus(STATUS_BATTLE_DESTROYED) then
        local e1=Effect.CreateEffect(c)
        e1:SetCode(EFFECT_SEND_REPLACE)
        e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
        e1:SetTarget(c81010016.reptg)
        e1:SetOperation(c81010016.repop)
        e1:SetLabelObject(c)
        e1:SetReset(RESET_EVENT+0x1fe0000)
        d:RegisterEffect(e1)
    end
end
function c81010016.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
    local c=e:GetHandler()
    if chk==0 then return c:GetDestination()==LOCATION_GRAVE and c:IsReason(REASON_BATTLE) and not c:IsImmuneToEffect(e) end
    return true
end
function c81010016.repop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local og=c:GetOverlayGroup()
         if og:GetCount()>0 then
            Duel.SendtoGrave(og,REASON_RULE)
         end
    Duel.Overlay(e:GetLabelObject(),Group.FromCards(c))
end
function c81010016.cost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,2,REASON_COST) end
    e:GetHandler():RemoveOverlayCard(tp,2,2,REASON_COST)
end
function c81010016.target(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsPlayerCanDiscardDeck(1-tp,3) end
    Duel.SetOperationInfo(0,CATEGORY_DECKDES,nil,0,1-tp,3)
end
function c81010016.cfilter(c)
    return c:IsLocation(LOCATION_GRAVE) and c:IsType(TYPE_SPELL)
end
function c81010016.operation(e,tp,eg,ep,ev,re,r,rp)
    Duel.DiscardDeck(1-tp,3,REASON_EFFECT)
    local g=Duel.GetOperatedGroup()
    local ct=g:FilterCount(c81010016.cfilter,nil)
    if ct==0 then return end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
    local dg=Duel.SelectMatchingCard(tp,aux.TRUE,tp,0,LOCATION_ONFIELD,1,ct,nil)
    Duel.HintSelection(dg)
    Duel.Destroy(dg,REASON_EFFECT)
end
