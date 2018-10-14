--市原仁奈
function c81011006.initial_effect(c)
    --atk up
    local e0=Effect.CreateEffect(c)
    e0:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
    e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
    e0:SetCode(EVENT_CHAINING)
    e0:SetRange(LOCATION_MZONE)
    e0:SetOperation(aux.chainreg)
    c:RegisterEffect(e0)
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(81011006,0))
    e1:SetCategory(CATEGORY_ATKCHANGE)
    e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
    e1:SetCode(EVENT_CHAIN_SOLVED)
    e1:SetRange(LOCATION_MZONE)
    e1:SetCountLimit(1)
    e1:SetCondition(c81011006.atkcon)
    e1:SetOperation(c81011006.atkop)
    c:RegisterEffect(e1)
    local e2=e1:Clone()
    e2:SetCode(81011006)
    c:RegisterEffect(e2)
    --gain
    local e3=Effect.CreateEffect(c)
    e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
    e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
    e3:SetCode(EVENT_BE_MATERIAL)
    e3:SetCountLimit(1,81011006)
    e3:SetCondition(c81011006.mtcon)
    e3:SetOperation(c81011006.mtop)
    c:RegisterEffect(e3)
end
function c81011006.atkcon(e,tp,eg,ep,ev,re,r,rp)
    return re:IsActiveType(TYPE_SPELL) and re:IsActiveType(TYPE_RITUAL) and re:IsHasType(EFFECT_TYPE_ACTIVATE)
        and rp==tp and e:GetHandler():GetFlagEffect(1)>0
end
function c81011006.atkop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if c:IsRelateToEffect(e) and c:IsFaceup() then
        local e1=Effect.CreateEffect(c)
        e1:SetType(EFFECT_TYPE_SINGLE)
        e1:SetCode(EFFECT_UPDATE_ATTACK)
        e1:SetValue(500)
        e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE)
        c:RegisterEffect(e1)
    end
end
function c81011006.mtcon(e,tp,eg,ep,ev,re,r,rp)
    return r==REASON_RITUAL and e:GetHandler():IsPreviousLocation(LOCATION_MZONE)
end
function c81011006.mtop(e,tp,eg,ep,ev,re,r,rp)
    if Duel.GetFlagEffect(tp,81011006)~=0 then return end
    local c=e:GetHandler()
    local g=eg:Filter(Card.IsType,nil,TYPE_RITUAL)
    local rc=g:GetFirst()
    if not rc then return end
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetCode(EFFECT_BATTLE_DESTROY_REDIRECT)
    e1:SetValue(LOCATION_REMOVED)
    e1:SetReset(RESET_EVENT+RESETS_STANDARD)
    rc:RegisterEffect(e1,true)
    if not rc:IsType(TYPE_EFFECT) then
        local e2=Effect.CreateEffect(c)
        e2:SetType(EFFECT_TYPE_SINGLE)
        e2:SetCode(EFFECT_ADD_TYPE)
        e2:SetValue(TYPE_EFFECT)
        e2:SetReset(RESET_EVENT+RESETS_STANDARD)
        rc:RegisterEffect(e2,true)
    end
    rc:RegisterFlagEffect(0,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(81011006,1))
    Duel.RegisterFlagEffect(tp,81011006,RESET_PHASE+PHASE_END,0,1)
end
