--Spiral Drill Impact!
function c32912377.initial_effect(c)
    --Activate
    local e1=Effect.CreateEffect(c)
    e1:SetCategory(CATEGORY_ATKCHANGE)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
    e1:SetHintTiming(TIMING_DAMAGE_STEP)
    e1:SetCondition(c32912377.condition)
    e1:SetTarget(c32912377.target)
    e1:SetOperation(c32912377.activate)
    c:RegisterEffect(e1)
end
function c32912377.cfilter(c)
    return c:IsFaceup() and c:IsCode(32912371,32912372)
end
function c32912377.condition(e,tp,eg,ep,ev,re,r,rp)
    local ct=Duel.GetMatchingGroupCount(c32912377.cfilter,tp,LOCATION_ONFIELD+LOCATION_GRAVE,LOCATION_ONFIELD+LOCATION_GRAVE,nil)
    return ct>0 and (Duel.GetCurrentPhase()~=PHASE_DAMAGE or not Duel.IsDamageCalculated())
end
function c32912377.filter(c)
    return c:IsFaceup() and c:IsSetCard(0x205)
end
function c32912377.target(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then
        local ct=Duel.GetMatchingGroupCount(c32912377.cfilter,tp,LOCATION_ONFIELD+LOCATION_GRAVE,LOCATION_ONFIELD+LOCATION_GRAVE,nil)
        if ct<=1 then return Duel.IsExistingMatchingCard(c32912377.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
        return true
    end
end
function c32912377.activate(e,tp,eg,ep,ev,re,r,rp)
    local g=Duel.GetMatchingGroup(c32912377.cfilter,tp,LOCATION_ONFIELD+LOCATION_GRAVE,LOCATION_ONFIELD+LOCATION_GRAVE,nil)
    local ct=g:GetCount()
    if ct>=1 then
       Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
        local g=Duel.SelectMatchingCard(tp,c32912377.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
        local tc=g:GetFirst()
        if tc then
            Duel.HintSelection(g)
            local tc=g:GetFirst()
            local atk=tc:GetBaseAttack()+tc:GetBaseDefense()
            local e1=Effect.CreateEffect(e:GetHandler())
            e1:SetType(EFFECT_TYPE_SINGLE)
            e1:SetCode(EFFECT_SET_ATTACK_FINAL)
            e1:SetValue(atk)
            e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
            tc:RegisterEffect(e1)
            local e2=e1:Clone()
            e2:SetCode(EFFECT_SET_DEFENSE_FINAL)
            tc:RegisterEffect(e2)
        end
    end
    if ct>=2 then
       local e3=Effect.CreateEffect(e:GetHandler())
        e3:SetType(EFFECT_TYPE_FIELD)
        e3:SetCode(EFFECT_CANNOT_DISEFFECT)
        e3:SetValue(c32912377.effectfilter)
        e3:SetReset(RESET_PHASE+PHASE_END)
        Duel.RegisterEffect(e3,tp)
    end
    if ct>=3 then
       local g=Duel.GetMatchingGroup(c32912377.filter,tp,LOCATION_MZONE,0,nil)
        local tc=g:GetFirst()
        while tc do
             local e4=Effect.CreateEffect(e:GetHandler())
             e4:SetType(EFFECT_TYPE_SINGLE)
             e4:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
             e4:SetTarget(c32912377.indtg)
             e4:SetValue(1)
             e4:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
             tc:RegisterEffect(e4)
             local e5=Effect.CreateEffect(e:GetHandler())
             e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
             e5:SetCode(EVENT_PRE_BATTLE_DAMAGE)
             e5:SetReset(RESET_PHASE+PHASE_END)
             e5:SetCondition(c32912377.damcon)
             e5:SetOperation(c32912377.damop)
             tc:RegisterEffect(e5)
             tc=g:GetNext()
        end
    end
end
function c32912377.effectfilter(e,ct)
    local te=Duel.GetChainInfo(ct,CHAININFO_TRIGGERING_EFFECT)
    local tc=te:GetHandler()
    return tc:IsSetCard(0x205)
end
function c32912377.indtg(e,c)
    return c:IsSetCard(0x205)
end
function c32912377.damcon(e,tp,eg,ep,ev,re,r,rp)
    return ep~=tp 
end
function c32912377.damop(e,tp,eg,ep,ev,re,r,rp)
    Duel.ChangeBattleDamage(ep,ev*2)
end