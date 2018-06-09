--传灵 一寸
local m=22600111
local cm=_G["c"..m]
function cm.initial_effect(c)
    --link summon
    aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsLinkType,TYPE_SPIRIT),1,1)
    c:EnableReviveLimit()
    c:SetSPSummonOnce(m)
    --remove
    local e1=Effect.CreateEffect(c)
    e1:SetCategory(CATEGORY_REMOVE)
    e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
    e1:SetCode(EVENT_BATTLE_START)
    e1:SetCondition(cm.rcon)
    e1:SetTarget(cm.rtg)
    e1:SetOperation(cm.rop)
    c:RegisterEffect(e1)
    --atk up
    local e1=Effect.CreateEffect(c)
    e1:SetCategory(CATEGORY_ATKCHANGE)
    e1:SetType(EFFECT_TYPE_IGNITION)
    e1:SetRange(LOCATION_MZONE)
    e1:SetCountLimit(1)
    e1:SetCost(cm.adcost)
    e1:SetOperation(cm.adop)
    c:RegisterEffect(e1)
    --return
    local e3=Effect.CreateEffect(c)
    e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
    e3:SetCode(EVENT_SPSUMMON_SUCCESS)
    e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
    e3:SetCondition(cm.retcon)
    e3:SetOperation(cm.retreg)
    c:RegisterEffect(e3)
    --
    local e4=Effect.CreateEffect(c)
    e4:SetType(EFFECT_TYPE_SINGLE)
    e4:SetCode(EFFECT_CANNOT_BE_LINK_MATERIAL)
    e4:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
    e4:SetValue(cm.linklimit)
    c:RegisterEffect(e4)
end
function cm.linklimit(e,c)
    if not c then return false end
    return not c:IsSetCard(0x261)
end
function cm.rcon(e,tp,eg,ep,ev,re,r,rp)
    local d=Duel.GetAttackTarget()
    return e:GetHandler()==Duel.GetAttacker() and d and ((d:IsFaceup() and d:GetAttack()>e:GetHandler():GetAttack()) or d:IsFacedown())
end
function cm.rtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return true end
    Duel.SetOperationInfo(0,CATEGORY_REMOVE,Duel.GetAttackTarget(),1,0,0)
end
function cm.rop(e,tp,eg,ep,ev,re,r,rp)
    local d=Duel.GetAttackTarget()
    if d:IsRelateToBattle() and ((d:GetAttack()>e:GetHandler():GetAttack()) or d:IsFacedown()) then
        Duel.Remove(d,POS_FACEUP,REASON_EFFECT)
    end
end
function cm.cfilter(c)
    return c:IsDiscardable()
end
function cm.adcost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(cm.cfilter,tp,LOCATION_HAND,0,1,nil) end
    local t=Duel.DiscardHand(tp,cm.cfilter,1,63,REASON_COST+REASON_DISCARD)
    e:SetLabel(t)
end
function cm.adop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local t=e:GetLabel()
    if c:IsRelateToEffect(e) and c:IsFaceup() then
        local e1=Effect.CreateEffect(c)
        e1:SetType(EFFECT_TYPE_SINGLE)
        e1:SetCode(EFFECT_UPDATE_ATTACK)
        e1:SetValue(1000*t)
        e1:SetReset(RESET_EVENT+0x1ff0000)
        c:RegisterEffect(e1)
    end
end
function cm.retcon(e,tp,eg,ep,ev,re,r,rp)
    return e:GetHandler():IsSummonType(SUMMON_TYPE_LINK)
end
function cm.retreg(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
    e1:SetDescription(1104)
    e1:SetCategory(CATEGORY_TODECK+CATEGORY_TOHAND)
    e1:SetCode(EVENT_PHASE+PHASE_END)
    e1:SetRange(LOCATION_MZONE)
    e1:SetCountLimit(1)
    e1:SetReset(RESET_EVENT+0x1ee0000+RESET_PHASE+PHASE_END)
    e1:SetCondition(aux.SpiritReturnCondition)
    e1:SetTarget(cm.rettg)
    e1:SetOperation(cm.retop)
    c:RegisterEffect(e1)
    local e2=e1:Clone()
    e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
    c:RegisterEffect(e2)
end
function cm.retfilter(c)
    return c:IsType(TYPE_MONSTER) and c:IsSetCard(0x261) and c:IsAbleToHand()
end
function cm.rettg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then
        if e:IsHasType(EFFECT_TYPE_TRIGGER_F) then
            return true
        else
            return Duel.GetMatchingGroupCount(cm.retfilter,tp,LOCATION_GRAVE,0,nil)>0
        end
    end
    Duel.SetOperationInfo(0,CATEGORY_TODECK,e:GetHandler(),1,0,0)
end
function cm.retop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if c:IsRelateToEffect(e) and c:IsFaceup() and Duel.SendtoDeck(c,nil,2,REASON_EFFECT)~=0
        and Duel.GetMatchingGroupCount(cm.retfilter,tp,LOCATION_GRAVE,0,nil)>0 then
        local g=Duel.GetMatchingGroup(cm.retfilter,tp,LOCATION_GRAVE,0,nil)
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
        local tg=Duel.SelectMatchingCard(tp,cm.retfilter,tp,LOCATION_GRAVE,0,1,1,nil)
        Duel.SendtoHand(tg,nil,REASON_EFFECT)
    end
end