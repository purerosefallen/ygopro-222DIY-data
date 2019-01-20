--七宝石的公主 蕾·菲耶
function c47551120.initial_effect(c)
    --pendulum summon
    aux.EnablePendulumAttribute(c)
    --splimit
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_FIELD)
    e1:SetRange(LOCATION_PZONE)
    e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
    e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CANNOT_DISABLE)
    e1:SetTargetRange(1,0)
    e1:SetTarget(c47551120.splimit)
    c:RegisterEffect(e1)  
    --draw
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(47551120,0))
    e2:SetCategory(CATEGORY_DRAW)
    e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
    e2:SetCode(EVENT_CHAIN_SOLVING)
    e2:SetRange(LOCATION_PZONE)
    e2:SetProperty(EFFECT_FLAG_DELAY)
    e2:SetCountLimit(1,47551120)
    e2:SetCondition(c47551120.drcon)
    e2:SetTarget(c47551120.drtg)
    e2:SetOperation(c47551120.drop)
    c:RegisterEffect(e2) 
    --yasuragi no kirameki
    local e3=Effect.CreateEffect(c)
    e3:SetDescription(aux.Stringid(47551120,1))
    e3:SetCategory(CATEGORY_DRAW+CATEGORY_RECOVER+CATEGORY_ATKCHANGE)
    e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
    e3:SetCode(EVENT_PHASE+PHASE_END)
    e3:SetRange(LOCATION_MZONE)
    e3:SetCountLimit(1,47551121)
    e3:SetTarget(c47551120.lptg)
    e3:SetOperation(c47551120.lpop)
    c:RegisterEffect(e3) 
    --reflect damage
    local e4=Effect.CreateEffect(c)
    e4:SetType(EFFECT_TYPE_FIELD)
    e4:SetCode(EFFECT_REFLECT_DAMAGE)
    e4:SetRange(LOCATION_MZONE)
    e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
    e4:SetTargetRange(1,0)
    e4:SetValue(c47551120.refcon)
    c:RegisterEffect(e4)
    --negate
    local e7=Effect.CreateEffect(c)
    e7:SetDescription(aux.Stringid(47551120,0))
    e7:SetCategory(CATEGORY_DESTROY+CATEGORY_NEGATE+CATEGORY_SPECIAL_SUMMON)
    e7:SetType(EFFECT_TYPE_QUICK_O)
    e7:SetCode(EVENT_CHAINING)
    e7:SetRange(LOCATION_HAND)
    e7:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
    e7:SetCondition(c47551120.negcon)
    e7:SetTarget(c47551120.negtg)
    e7:SetOperation(c47551120.negop)
    c:RegisterEffect(e7)
end
function c47551120.splimit(e,c,tp,sumtp,sumpos)
    return not c:IsType(TYPE_PENDULUM) and bit.band(sumtp,SUMMON_TYPE_PENDULUM)==SUMMON_TYPE_PENDULUM
end
function c47551120.drcon(e,tp,eg,ep,ev,re,r,rp)
    return rp==tp and re:IsHasType(EFFECT_TYPE_ACTIVATE) and re:IsActiveType(TYPE_PENDULUM) and re:GetHandler():IsSetCard(0x5d0) and e:GetHandler()~=re:GetHandler()
end
function c47551120.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsPlayerCanDraw(tp,1) end
    Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c47551120.drop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if not e:GetHandler():IsRelateToEffect(e) then return end
    if Duel.Draw(tp,1,REASON_EFFECT)~=0 then
       Duel.Destroy(c,REASON_EFFECT)
    end
end
function c47551120.lptg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsPlayerCanDraw(tp,1) end
    Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
    Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,500)
end
function c47551120.lpop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if not c:IsLocation(LOCATION_MZONE) then return end
    local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,LOCATION_MZONE,0,nil)
    local tc=g:GetFirst()
    while tc do
        local e3=Effect.CreateEffect(c)
        e3:SetType(EFFECT_TYPE_SINGLE)
        e3:SetCode(EFFECT_UPDATE_ATTACK)
        e3:SetReset(RESET_EVENT+RESETS_STANDARD)
        e3:SetValue(500)
        tc:RegisterEffect(e3)
        tc=g:GetNext()
    end
    Duel.Recover(tp,500,REASON_EFFECT)
    Duel.Draw(tp,1,REASON_EFFECT)
end
function c47551120.refcon(e,re,val,r,rp,rc)
    return bit.band(r,REASON_EFFECT)~=0 and rp==1-e:GetHandler():GetControler()  and e:GetHandler():IsAttackPos()
end
function c47551120.negcon(e,tp,eg,ep,ev,re,r,rp)
    return Duel.IsChainNegatable(ev) and aux.damcon1(e,tp,eg,ep,ev,re,r,rp)
end
function c47551120.negtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return true end
    Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c47551120.negop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if not c:IsRelateToEffect(e) then return end
    if Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)~=0 then
        Duel.NegateActivation(ev)
        Duel.Destroy(eg,REASON_EFFECT)
    end
end