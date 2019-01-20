--掩护射击
function c47554018.initial_effect(c)
    local e0=Effect.CreateEffect(c)
    e0:SetType(EFFECT_TYPE_SINGLE)
    e0:SetCode(EFFECT_TRAP_ACT_IN_SET_TURN)
    e0:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
    e0:SetCondition(c47554018.setcon)
    c:RegisterEffect(e0)    
    --activate
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
    c:RegisterEffect(e1)
    --Cannot target
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_FIELD)
    e2:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
    e2:SetRange(LOCATION_SZONE)
    e2:SetTargetRange(LOCATION_MZONE,0)
    e2:SetTarget(aux.TargetBoolFunction(Card.IsRace,RACE_SPELLCASTER))
    e2:SetValue(aux.tgoval)
    c:RegisterEffect(e2)
    local e5=e2:Clone()
    e5:SetTarget(aux.TargetBoolFunction(Card.IsRace,RACE_WARRIOR))
    c:RegisterEffect(e5)
    --indes
    local e3=Effect.CreateEffect(c)
    e3:SetType(EFFECT_TYPE_FIELD)
    e3:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
    e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e3:SetRange(LOCATION_SZONE)
    e3:SetTargetRange(LOCATION_MZONE,0)
    e3:SetTarget(aux.TargetBoolFunction(Card.IsRace,RACE_SPELLCASTER))
    e3:SetValue(aux.indoval)
    c:RegisterEffect(e3)
    local e6=e3:Clone()
    e6:SetTarget(aux.TargetBoolFunction(Card.IsRace,RACE_WARRIOR))
    c:RegisterEffect(e6)
    --destroy
    local e4=Effect.CreateEffect(c)
    e4:SetDescription(aux.Stringid(47554018,0))
    e4:SetCategory(CATEGORY_DESTROY)
    e4:SetType(EFFECT_TYPE_QUICK_O)
    e4:SetCode(EVENT_FREE_CHAIN)
    e4:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e4:SetRange(LOCATION_SZONE)
    e4:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
    e4:SetCountLimit(1,47554018)
    e4:SetTarget(c47554018.destg)
    e4:SetOperation(c47554018.desop)
    c:RegisterEffect(e4)
end
function c47554018.setcon(e,tp,eg,ep,ev,re,r,rp)
    local ct1=Duel.GetFieldGroupCount(tp,LOCATION_ONFIELD+LOCATION_HAND,0)
    local ct2=Duel.GetFieldGroupCount(tp,0,LOCATION_ONFIELD+LOCATION_HAND)
    if ct1>=ct2 then return false end
end
function c47554018.desfilter(c)
    return c:IsFaceup() and c:IsSetCard(0x5d0) and c:IsType(TYPE_PENDULUM) and c:GetSummonLocation()==LOCATION_EXTRA 
end
function c47554018.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return false end
    if chk==0 then return Duel.IsExistingTarget(nil,tp,0,LOCATION_ONFIELD,2,nil) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
    local g=Duel.SelectTarget(tp,nil,tp,0,LOCATION_ONFIELD,2,2,nil)
    Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,2,0,0)
end
function c47554018.filter(c)
    return c:IsFaceup()
end
function c47554018.desop(e,tp,eg,ep,ev,re,r,rp)
    if not e:GetHandler():IsRelateToEffect(e) then return end
    local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
    if Duel.Destroy(g,REASON_EFFECT)~=2 then
        local g=Duel.GetMatchingGroup(c47554018.filter,tp,0,LOCATION_MZONE,nil)
        if g:GetCount()>0 then
            local tg=g:GetMaxGroup(Card.GetAttack)
            if tg:GetCount()>1 then
                Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_TOGRAVE)
                local sg=tg:Select(1-tp,1,1,nil)
                Duel.HintSelection(sg)
                Duel.Remove(sg,POS_FACEUP,REASON_RULE)
            end
        end
    end
end