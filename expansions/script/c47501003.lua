--军神 格里姆尼尔
function c47501003.initial_effect(c)
    --xyz summon
    c:EnableReviveLimit()
    aux.AddXyzProcedureLevelFree(c,c47501003.mfilter,nil,4,4)      
    --shield
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
    e1:SetCode(EVENT_SPSUMMON_SUCCESS)
    e1:SetCondition(c47501003.sdcon)
    e1:SetOperation(c47501003.sdop)
    c:RegisterEffect(e1) 
    --Break
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(47501003,0))
    e2:SetType(EFFECT_TYPE_QUICK_O)
    e2:SetCode(EVENT_FREE_CHAIN)
    e2:SetCategory(CATEGORY_DESTROY+CATEGORY_ATKCHANGE)
    e2:SetRange(LOCATION_MZONE)
    e2:SetCountLimit(1)
    e2:SetCost(c47501003.atkcost)
    e2:SetTarget(c47501003.atktg)
    e2:SetOperation(c47501003.atkop)
    c:RegisterEffect(e2)
    --shield
    local e3=Effect.CreateEffect(c)
    e3:SetDescription(aux.Stringid(47501003,1))
    e3:SetType(EFFECT_TYPE_QUICK_O)
    e3:SetCode(EVENT_FREE_CHAIN)
    e3:SetRange(LOCATION_MZONE)
    e3:SetCountLimit(1,47501003+EFFECT_COUNT_CODE_DUEL)
    e3:SetCost(c47501003.lpcost)
    e3:SetOperation(c47501003.lpop)
    c:RegisterEffect(e3) 
    --destroy
    local e4=Effect.CreateEffect(c)
    e4:SetCategory(CATEGORY_DAMAGE)
    e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
    e4:SetCode(EVENT_PHASE+PHASE_END)
    e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
    e4:SetRange(LOCATION_MZONE)
    e4:SetCountLimit(1,47501103+EFFECT_COUNT_CODE_DUEL)
    e4:SetCondition(c47501003.damcon)
    e4:SetTarget(c47501003.damtg)
    e4:SetOperation(c47501003.damop)
    c:RegisterEffect(e4)   
    --spsummon bgm
    local e9=Effect.CreateEffect(c)
    e9:SetDescription(aux.Stringid(47501003,2))
    e9:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
    e9:SetCode(EVENT_SPSUMMON_SUCCESS)
    e9:SetOperation(c47501003.spsuc)
    c:RegisterEffect(e9)
    --atk bgm
    local e10=Effect.CreateEffect(c)
    e10:SetDescription(aux.Stringid(47501003,3))
    e10:SetCategory(CATEGORY_ATKCHANGE)
    e10:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
    e10:SetCode(EVENT_ATTACK_ANNOUNCE)
    e10:SetOperation(c47501003.atksuc)
    c:RegisterEffect(e10)
end
function c47501003.spsuc(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_MUSIC,0,aux.Stringid(47501003,4))
end
function c47501003.atksuc(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SOUND,0,aux.Stringid(47501003,5))
end
function c47501003.mfilter(c)
    return c:GetSummonLocation()==LOCATION_EXTRA and c:IsAttribute(ATTRIBUTE_WIND)
end
function c47501003.sdcon(e,tp,eg,ep,ev,re,r,rp)
    return e:GetHandler():IsSummonType(SUMMON_TYPE_XYZ)
end
function c47501003.sdop(e,tp,eg,ep,ev,re,r,rp)
    local e1=Effect.CreateEffect(e:GetHandler())
    e1:SetType(EFFECT_TYPE_FIELD)
    e1:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
    e1:SetTargetRange(LOCATION_MZONE,0)
    e1:SetReset(RESET_PHASE+PHASE_END,2)
    e1:SetValue(1)
    Duel.RegisterEffect(e1,tp)
    local e2=e1:Clone()
    e2:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
    Duel.RegisterEffect(e2,tp)
    local e3=Effect.CreateEffect(c)
    e3:SetType(EFFECT_TYPE_FIELD)
    e3:SetCode(EFFECT_IMMUNE_EFFECT)
    e3:SetRange(LOCATION_MZONE)
    e3:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
    e3:SetTargetRange(LOCATION_MZONE,0)
    e3:SetTarget(c47501003.indtg)
    e3:SetValue(c47501003.efilter)
    e3:SetReset(RESET_PHASE+PHASE_END,2)
    Duel.RegisterEffect(e3,tp)
end
function c47501003.indtg(e,c)
    local te,g=Duel.GetChainInfo(0,CHAININFO_TRIGGERING_EFFECT,CHAININFO_TARGET_CARDS)
    return not te or not te:IsHasProperty(EFFECT_FLAG_CARD_TARGET) or not g or not g:IsContains(c)
end
function c47501003.efilter(e,te)
    return te:GetOwnerPlayer()~=e:GetHandlerPlayer()
end
function c47501003.atkcost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,2,REASON_COST) end
    e:GetHandler():RemoveOverlayCard(tp,2,2,REASON_COST)
end
function c47501003.atktg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(Card.IsFaceup,tp,0,LOCATION_MZONE,1,nil) end
end
function c47501003.atkop(e,tp,eg,ep,ev,re,r,rp)
    local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,0,LOCATION_MZONE,nil)
    local c=e:GetHandler()
    local tc=g:GetFirst()
    while tc do
        local preatk=tc:GetAttack()
        local e1=Effect.CreateEffect(c)
        e1:SetType(EFFECT_TYPE_SINGLE)
        e1:SetCode(EFFECT_UPDATE_ATTACK)
        e1:SetValue(-3000)
        e1:SetReset(RESET_EVENT+RESETS_STANDARD)
        tc:RegisterEffect(e1)
        if preatk~=0 and tc:IsAttack(0) then dg:AddCard(tc) end
        tc=g:GetNext()
    end
    Duel.Destroy(dg,REASON_EFFECT)
end
function c47501003.lpcost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,4,REASON_COST) end
    e:GetHandler():RemoveOverlayCard(tp,4,4,REASON_COST)
end
function c47501003.lpop(e,tp,eg,ep,ev,re,r,rp)
    Duel.SetLP(tp,10000)
    e:GetHandler():RegisterFlagEffect(47501003,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1)
end
function c47501003.damcon(e,tp,eg,ep,ev,re,r,rp)
    return e:GetHandler():GetFlagEffect(47501003)~=0
end
function c47501003.damtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return true end
    Duel.SetTargetPlayer(1-tp)
    Duel.SetTargetParam(3000)
    Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,3000)
    Duel.SetChainLimit(aux.FALSE)
end
function c47501003.damop(e,tp,eg,ep,ev,re,r,rp)
    local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
    Duel.Damage(p,d,REASON_EFFECT)
end