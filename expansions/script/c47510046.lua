--觉醒魔王 神崎兰子
local m=47510046
local cm=_G["c"..m]
function c47510046.initial_effect(c)
       --pendulum summon
    aux.EnablePendulumAttribute(c)
    --rsummon
    c:EnableReviveLimit() 
    --cannot be break
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_FIELD)
    e1:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
    e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
    e1:SetRange(LOCATION_PZONE)
    e1:SetTargetRange(LOCATION_MZONE,0)
    e1:SetTarget(c47510046.tgtg)
    e1:SetValue(1)
    c:RegisterEffect(e1)
    local e2=e1:Clone()
    e2:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
    c:RegisterEffect(e2)
    --boost
    local e3=Effect.CreateEffect(c)
    e3:SetType(EFFECT_TYPE_FIELD)
    e3:SetCode(EFFECT_UPDATE_ATTACK)
    e3:SetRange(LOCATION_PZONE)
    e3:SetTargetRange(LOCATION_MZONE,0)
    e3:SetTarget(c47510046.tgtg)
    e3:SetValue(800)
    c:RegisterEffect(e3)
    local e4=e3:Clone()
    e4:SetCode(EFFECT_UPDATE_DEFENSE)
    c:RegisterEffect(e4)
    --Remove
    local e5=Effect.CreateEffect(c)
    e5:SetDescription(aux.Stringid(47510046,0))
    e5:SetCategory(CATEGORY_REMOVE)
    e5:SetType(EFFECT_TYPE_QUICK_O)
    e5:SetRange(LOCATION_MZONE)
    e5:SetCode(EVENT_FREE_CHAIN)
    e5:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e5:SetCountLimit(1)
    e5:SetTarget(c47510046.rtg)
    e5:SetOperation(c47510046.rop)
    c:RegisterEffect(e5)  
    --immune
    local e6=Effect.CreateEffect(c)
    e6:SetType(EFFECT_TYPE_SINGLE)
    e6:SetCode(EFFECT_IMMUNE_EFFECT)
    e6:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e6:SetRange(LOCATION_MZONE)
    e6:SetCondition(c47510046.imcon)
    e6:SetValue(c47510046.efilter)
    c:RegisterEffect(e6) 
    --atk
    local e7=Effect.CreateEffect(c)
    e7:SetDescription(aux.Stringid(47510046,1))
    e7:SetCategory(CATEGORY_ATKCHANGE)
    e7:SetType(EFFECT_TYPE_QUICK_O)
    e7:SetRange(LOCATION_MZONE)
    e7:SetCode(EVENT_PRE_DAMAGE_CALCULATE)
    e7:SetCondition(c47510046.atkcon)
    e7:SetCost(c47510046.atkcost)
    e7:SetOperation(c47510046.atkop)
    c:RegisterEffect(e7)
        --pendulum
    local e8=Effect.CreateEffect(c)
    e8:SetDescription(aux.Stringid(47510046,2))
    e8:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e8:SetCode(EVENT_DESTROYED)
    e8:SetProperty(EFFECT_FLAG_DELAY)
    e8:SetCondition(c47510046.pencon)
    e8:SetTarget(c47510046.pentg)
    e8:SetOperation(c47510046.penop)
    c:RegisterEffect(e8)
    --back
    local e9=Effect.CreateEffect(c)
    e9:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
    e9:SetCode(EVENT_ADJUST)
    e9:SetRange(LOCATION_DECK+LOCATION_GRAVE+LOCATION_REMOVED+LOCATION_HAND+LOCATION_EXTRA)
    e9:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_SET_AVAILABLE)
    e9:SetCondition(c47510046.backon)
    e9:SetOperation(c47510046.backop)
    c:RegisterEffect(e9)
end
function c47510046.tgtg(e,c)
    return c:IsRace(RACE_FAIRY)
end
function c47510046.rtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return chkc:IsLocation(LOCATION_ONFIELD) and chkc:IsAbleToRemove() end
    if chk==0 then return Duel.IsExistingTarget(Card.IsAbleToRemove,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
    local g=Duel.SelectTarget(tp,Card.IsAbleToRemove,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
    Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,1,0,0)
end
function c47510046.rop(e,tp,eg,ep,ev,re,r,rp)
    local tc=Duel.GetFirstTarget()
    if tc:IsRelateToEffect(e) and Duel.Remove(tc,0,REASON_EFFECT+REASON_TEMPORARY)~=0 then
        tc:RegisterFlagEffect(47510046,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1)
        local e1=Effect.CreateEffect(e:GetHandler())
        e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
        e1:SetCode(EVENT_PHASE+PHASE_END)
        e1:SetReset(RESET_PHASE+PHASE_END)
        e1:SetLabelObject(tc)
        e1:SetCountLimit(1)
        e1:SetCondition(c47510046.retcon)
        e1:SetOperation(c47510046.retop)
        Duel.RegisterEffect(e1,tp)
    end
end
function c47510046.retcon(e,tp,eg,ep,ev,re,r,rp)
    return e:GetLabelObject():GetFlagEffect(47510046)~=0
end
function c47510046.retop(e,tp,eg,ep,ev,re,r,rp)
    Duel.ReturnToField(e:GetLabelObject())
end
function c47510046.cfilter1(c)
    return c:IsFaceup() and c:IsAttribute(ATTRIBUTE_DARK)
end
function c47510046.imcon(e,tp,eg,ep,ev,re,r,rp)
    return Duel.IsExistingMatchingCard(c47510046.cfilter1,tp,LOCATION_MZONE,0,2,nil)
end
function c47510046.efilter(e,te)
    return te:GetOwner()~=e:GetOwner()
end
function c47510046.atkcon(e,tp,eg,ep,ev,re,r,rp)
    return e:GetHandler():GetBattleTarget()~=nil
end
function c47510046.atkcost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,nil) end
    Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_COST+REASON_DISCARD)
end
function c47510046.atkop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if c:IsRelateToEffect(e) and c:IsFaceup() then
        local e1=Effect.CreateEffect(c)
        e1:SetType(EFFECT_TYPE_SINGLE)
        e1:SetCode(EFFECT_SET_ATTACK_FINAL)
        e1:SetReset(RESET_PHASE+PHASE_DAMAGE_CAL)
        e1:SetValue(5100)
        c:RegisterEffect(e1)
    end
end
function c47510046.pencon(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    return bit.band(r,REASON_EFFECT+REASON_BATTLE)~=0 and c:IsPreviousLocation(LOCATION_MZONE) and c:IsFaceup()
end
function c47510046.pentg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1) end
end
function c47510046.penop(e,tp,eg,ep,ev,re,r,rp)
    if not Duel.CheckLocation(tp,LOCATION_PZONE,0) and not Duel.CheckLocation(tp,LOCATION_PZONE,1) then return false end
    local c=e:GetHandler()
    if c:IsRelateToEffect(e) then
        Duel.MoveToField(c,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
    end
end
function c47510046.backon(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    return c.dfc_front_side and c:GetOriginalCode()==c.dfc_back_side
end
function c47510046.backop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local tcode=c.dfc_front_side
    c:SetEntityCode(tcode)
    Duel.ConfirmCards(tp,Group.FromCards(c))
    Duel.ConfirmCards(1-tp,Group.FromCards(c))
    c:ReplaceEffect(tcode,0,0)
end