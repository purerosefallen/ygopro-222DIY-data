--尤伊西丝-天终之型
local m=47510224
local cm=_G["c"..m]
function c47510224.initial_effect(c)
    --pendulum summon
    aux.EnablePendulumAttribute(c)
    --synchro summon
    aux.AddSynchroProcedure(c,nil,aux.NonTuner(Card.IsType,TYPE_PENDULUM),1)
    c:EnableReviveLimit()
    local e0=Effect.CreateEffect(c)
    e0:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
    e0:SetRange(LOCATION_PZONE)
    e0:SetCode(EVENT_LEAVE_FIELD)
    e0:SetCondition(c47510224.spcon)
    e0:SetTarget(c47510224.sptg)
    e0:SetOperation(c47510224.spop)
    c:RegisterEffect(e0)
    --Change
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(47510224,0))
    e1:SetType(EFFECT_TYPE_IGNITION)
    e1:SetRange(LOCATION_MZONE)
    e1:SetCondition(c47510224.chcon)
    e1:SetTarget(c47510224.changetg)
    e1:SetOperation(c47510224.changeop)
    c:RegisterEffect(e1) 
    --itousennen
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(47510224,1))
    e2:SetType(EFFECT_TYPE_IGNITION)
    e2:SetRange(LOCATION_MZONE)
    e2:SetCountLimit(1)
    e2:SetCode(c47510224.atkcost)
    e2:SetOperation(c47510224.atkop)
    c:RegisterEffect(e2) 
    --attack twice
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_SINGLE)
    e2:SetCode(EFFECT_EXTRA_ATTACK)
    e2:SetCondition(c47510224.dacon)
    e2:SetValue(1)
    c:RegisterEffect(e2)
    --back
    local e9=Effect.CreateEffect(c)
    e9:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
    e9:SetCode(EVENT_ADJUST)
    e9:SetRange(LOCATION_DECK+LOCATION_GRAVE+LOCATION_REMOVED+LOCATION_HAND+LOCATION_EXTRA)
    e9:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_SET_AVAILABLE)
    e9:SetCondition(c47510224.backon)
    e9:SetOperation(c47510224.backop)
    c:RegisterEffect(e9)    
end
function c47510224.cfilter(c,tp)
    return c:GetPreviousControler()==tp and c:IsPreviousLocation(LOCATION_MZONE)
        and (c:IsReason(REASON_EFFECT) and c:GetReasonPlayer()==1-tp)
end
function c47510224.spcon(e,tp,eg,ep,ev,re,r,rp)
    return eg:IsExists(c47510224.cfilter,1,nil,tp)
end
function c47510224.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
        and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c47510224.spop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if c:IsRelateToEffect(e) then
        Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
    end
end
function c47510224.chcon(e)
    return e:GetHandler():GetFlagEffect(47510223)==0
end
function c47510224.changetg(e,tp,eg,ep,ev,re,r,rp,chk)
    local c=e:GetHandler()
    if chk==0 then return c.dfc_front_side and c.dfc_back_side==c:GetOriginalCode() end
    Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
end
function c47510224.changeop(e,tp,eg,ep,ev,re,r,rp,chk)
    local c=e:GetHandler()
    if not c:IsRelateToEffect(e) or c:IsFacedown() or c:IsImmuneToEffect(e) then return end
    local tcode=c.dfc_front_side
    c:SetEntityCode(tcode,true)
    if c:ReplaceEffect(tcode,0,0) then 
    c:RegisterFlagEffect(47510223,RESET_EVENT+0x7e0000+RESET_PHASE+PHASE_END,0,1)
    end
end
function c47510224.atkcost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return true end
    Duel.PayLPCost(tp,2000)
end
function c47510224.atkop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if c:IsFaceup() and c:IsRelateToEffect(e) then
        local e1=Effect.CreateEffect(c)
        e1:SetType(EFFECT_TYPE_SINGLE)
        e1:SetCode(EFFECT_SET_ATTACK_FINAL)
        e1:SetValue(7000)
        e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE+RESET_PHASE+PHASE_END)
        c:RegisterEffect(e1)
        local e2=Effect.CreateEffect(c)
        e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
        e2:SetCode(EVENT_ATTACK_ANNOUNCE)
        e2:SetCondition(c47510224.actcon)
        e2:SetOperation(c47510224.inmop)
        e2:SetReset(RESET_PHASE+PHASE_END)
        c:RegisterEffect(e2)
        local e3=e2:Clone()
        e3:SetCode(EVENT_BE_BATTLE_TARGET)
        c:RegisterEffect(e3)
    end
    c:RegisterFlagEffect(47510224,RESET_EVENT+0x7e0000+RESET_PHASE+PHASE_END,0,1)
end
function c47510224.actcon(e,tp,eg,ep,ev,re,r,rp)
    local tc=Duel.GetAttacker()
    if tc:IsControler(1-tp) then tc=Duel.GetAttackTarget() end
    return tc and tc:IsControler(tp)
end
function c47510224.inmop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if c:IsRelateToEffect(e) and c:IsFaceup() then
        local e1=Effect.CreateEffect(c)
        e1:SetType(EFFECT_TYPE_SINGLE)
        e1:SetCode(EFFECT_IMMUNE_EFFECT)
        e1:SetValue(c47510224.efilter)
        e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
        c:RegisterEffect(e1)
    end
end
function c47510224.efilter(e,re)
    return re:GetOwner()~=e:GetOwner()
end
function c47510224.dacon(e)
    return e:GetHandler():GetFlagEffect(47510224)==0
end
function c47510224.backon(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    return c.dfc_front_side and c:GetOriginalCode()==c.dfc_back_side
end
function c47510224.backop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local tcode=c.dfc_front_side
    c:SetEntityCode(tcode)
    Duel.ConfirmCards(tp,Group.FromCards(c))
    Duel.ConfirmCards(1-tp,Group.FromCards(c))
    c:ReplaceEffect(tcode,0,0)
end