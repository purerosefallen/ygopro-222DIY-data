--五花的巫女 蒂安萨
function c47551115.initial_effect(c)
    --pendulum summon
    aux.EnablePendulumAttribute(c)  
    aux.EnableReviveLimitPendulumSummonable(c,LOCATION_HAND+LOCATION_EXTRA)
    --special summon
    local e0=Effect.CreateEffect(c)
    e0:SetDescription(aux.Stringid(47551115,0))
    e0:SetType(EFFECT_TYPE_FIELD)
    e0:SetCode(EFFECT_SPSUMMON_PROC)
    e0:SetProperty(EFFECT_FLAG_UNCOPYABLE)
    e0:SetRange(LOCATION_PZONE)
    e0:SetCountLimit(1,47551115)
    e0:SetCondition(c47551115.hspcon)
    e0:SetOperation(c47551115.hspop)
    e0:SetValue(SUMMON_TYPE_RITUAL)
    c:RegisterEffect(e0) 
    --smile world
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(47551115,1))
    e1:SetType(EFFECT_TYPE_FIELD)
    e1:SetCode(EFFECT_UPDATE_ATTACK)
    e1:SetValue(c47551115.atkval)
    e1:SetRange(LOCATION_PZONE)
    e1:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
    c:RegisterEffect(e1)   
    --summon success
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
    e2:SetCode(EVENT_SPSUMMON_SUCCESS)
    e2:SetOperation(c47551115.sumsuc)
    c:RegisterEffect(e2) 
    --draw
    local e3=Effect.CreateEffect(c)
    e3:SetCategory(CATEGORY_DRAW)
    e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
    e3:SetRange(LOCATION_MZONE)
    e3:SetCode(EVENT_LEAVE_FIELD)
    e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
    e3:SetCountLimit(1,47551116)
    e3:SetCondition(c47551115.drcon)
    e3:SetTarget(c47551115.drtg)
    e3:SetOperation(c47551115.drop)
    c:RegisterEffect(e3)
    --buff
    local e4=Effect.CreateEffect(c)
    e4:SetType(EFFECT_TYPE_FIELD)
    e4:SetCode(EFFECT_IMMUNE_EFFECT)
    e4:SetRange(LOCATION_MZONE)
    e4:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
    e4:SetTargetRange(LOCATION_MZONE,0)
    e4:SetTarget(c47551115.target)
    e4:SetValue(c47551115.efilter)
    c:RegisterEffect(e4)
    local e5=Effect.CreateEffect(c)
    e5:SetType(EFFECT_TYPE_FIELD)
    e5:SetCode(EFFECT_UPDATE_ATTACK)
    e5:SetRange(LOCATION_MZONE)
    e5:SetTargetRange(LOCATION_MZONE,0)
    e5:SetTarget(c47551115.bftg)
    e5:SetValue(1000)
    c:RegisterEffect(e5)
end
function c47551115.atkval(c,tp)
    local ct=Duel.GetFieldGroupCount(tp,LOCATION_MZONE,LOCATION_MZONE)
    return ct*200
end
function c47551115.mfilter(c)
    return c:IsType(TYPE_PENDULUM) and c:IsFaceup()
end
function c47551115.hspcon(e,c)
    if c==nil then return true end
    local tp=c:GetControler()
    return Duel.IsExistingMatchingCard(c47551115.mfilter,tp,LOCATION_EXTRA,0,2,nil,e,tp)
end
function c47551115.hspop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local g=Duel.SelectMatchingCard(tp,c47551115.mfilter,tp,LOCATION_EXTRA,0,2,2,nil)
    Duel.SendtoGrave(g,REASON_COST)
end
function c47551115.sumsuc(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if not c:IsSummonType(SUMMON_TYPE_RITUAL) then return end
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_FIELD)
    e1:SetCode(EFFECT_EXTRA_ATTACK)
    e1:SetTargetRange(LOCATION_MZONE,0)
    e1:SetValue(1)
    e1:SetReset(RESET_PHASE+PHASE_END)
    Duel.RegisterEffect(e1,tp)
end
function c47551115.cfilter(c,tp)
    return c:GetPreviousControler()==tp and c:IsPreviousLocation(LOCATION_ONFIELD) and c:IsReason(REASON_EFFECT) and c:GetReasonPlayer()==1-tp and c:IsType(TYPE_PENDULUM)
end
function c47551115.drcon(e,tp,eg,ep,ev,re,r,rp)
    return eg:IsExists(c47551115.cfilter,1,nil,tp)
end
function c47551115.filter(c)
    return c:IsFaceup() and c:IsType(TYPE_PENDULUM)
end
function c47551115.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
    local ct=Duel.GetMatchingGroupCount(c47551115.filter,tp,LOCATION_MZONE,0,nil)
    if chk==0 then return ct>0 and Duel.IsPlayerCanDraw(tp,ct) end
    Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,ct)
end
function c47551115.drop(e,tp,eg,ep,ev,re,r,rp)
    local ct=Duel.GetMatchingGroupCount(c47551115.filter,tp,LOCATION_MZONE,0,nil)
    Duel.Draw(tp,ct,REASON_EFFECT)
end
function c47551115.target(e,c)
    local te,g=Duel.GetChainInfo(0,CHAININFO_TRIGGERING_EFFECT,CHAININFO_TARGET_CARDS)
    return (not te or not te:IsHasProperty(EFFECT_FLAG_CARD_TARGET) or not g or not g:IsContains(c)) and c~=e:GetHandler()
end
function c47551115.bftg(e,c)
    return c~=e:GetHandler()
end
function c47551115.efilter(e,te)
    return te:GetOwnerPlayer()~=e:GetHandlerPlayer()
end