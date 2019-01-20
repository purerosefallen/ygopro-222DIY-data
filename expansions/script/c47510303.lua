--白纯蝶 希尔芙
function c47510303.initial_effect(c)
    --pendulum summon
    aux.EnablePendulumAttribute(c)  
    --copy
    local e1=Effect.CreateEffect(c)
    e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e1:SetType(EFFECT_TYPE_IGNITION)
    e1:SetRange(LOCATION_PZONE)
    e1:SetCountLimit(1,47510303)
    e1:SetCost(c47510303.cpcost)
    e1:SetTarget(c47510303.cptg)
    e1:SetOperation(c47510303.cpop)
    c:RegisterEffect(e1) 
    --Draw
    local e3=Effect.CreateEffect(c)
    e3:SetCategory(CATEGORY_HANDES+CATEGORY_DRAW)
    e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e3:SetCode(EVENT_SPSUMMON_SUCCESS)
    e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
    e3:SetCountLimit(1,47510305)
    e3:SetTarget(c47510303.drtg)
    e3:SetOperation(c47510303.drop)
    c:RegisterEffect(e3)
    local e2=e3:Clone()
    e2:SetCode(EVENT_SUMMON_SUCCESS)
    c:RegisterEffect(e2)
    --sunmoneffect
    local e4=Effect.CreateEffect(c)
    e4:SetType(EFFECT_TYPE_IGNITION)
    e4:SetRange(LOCATION_EXTRA)
    e4:SetCountLimit(1,47510000)
    e4:SetCost(c47510303.sscost)
    e4:SetOperation(c47510303.ssop)
    c:RegisterEffect(e4)
    c47510303.ss_effect=e4
    --atk
    local e5=Effect.CreateEffect(c)
    e5:SetType(EFFECT_TYPE_FIELD)
    e5:SetCode(EFFECT_UPDATE_ATTACK)
    e5:SetRange(LOCATION_MZONE)
    e5:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
    e5:SetTarget(c47510303.bftg)
    e5:SetValue(1000)
    c:RegisterEffect(e5)
    local e8=e5:Clone()
    e8:SetCode(EFFECT_UPDATE_DEFENSE)
    c:RegisterEffect(e8)
    local e6=Effect.CreateEffect(c)
    e6:SetType(EFFECT_TYPE_FIELD)
    e6:SetCode(EFFECT_UPDATE_ATTACK)
    e6:SetRange(LOCATION_MZONE)
    e6:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
    e6:SetTarget(c47510303.bftg1)
    e6:SetValue(-1000)
    c:RegisterEffect(e6)
    e9=e6:Clone()
    e9:SetCode(EFFECT_UPDATE_DEFENSE)
    c:RegisterEffect(e9)
end
function c47510303.xfilter(c)
    return c:IsFaceup() and c:IsType(TYPE_PENDULUM)
end
function c47510303.cpcost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c47510303.xfilter,tp,LOCATION_EXTRA,0,1,nil) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
    local g=Duel.SelectMatchingCard(tp,c47510303.xfilter,tp,LOCATION_EXTRA,0,1,1,nil)
    e:SetLabel(g:GetFirst():GetCode())
    Duel.SendtoGrave(g,REASON_COST)
end
function c47510303.cptg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingTarget(aux.TRUE,tp,LOCATION_MZONE,0,1,nil) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SELECT)
    local g=Duel.SelectTarget(tp,aux.TRUE,tp,LOCATION_MZONE,0,1,1,nil)
end
function c47510303.cpop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local tc=Duel.GetFirstTarget()
    if tc then
        local code=e:GetLabel()
        local e1=Effect.CreateEffect(c)
        e1:SetType(EFFECT_TYPE_SINGLE)
        e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
        e1:SetCode(EFFECT_CHANGE_CODE)
        e1:SetValue(code)
        e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
        tc:RegisterEffect(e1)
        tc:CopyEffect(code,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,1)
    end
end
function c47510303.sscost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return e:GetHandler():IsAbleToGraveAsCost() end
    Duel.SendtoGrave(e:GetHandler(),REASON_COST)
end
function c47510303.ssop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_FIELD)
    e1:SetCode(EFFECT_UPDATE_ATTACK)
    e1:SetTargetRange(0,LOCATION_MZONE)
    e1:SetValue(-1500)
    e1:SetReset(RESET_PHASE+PHASE_END)
    Duel.RegisterEffect(e1,tp) 
    local e3=e1:Clone()
    e3:SetCode(EFFECT_UPDATE_DEFENSE)
    Duel.RegisterEffect(e3,tp)
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_FIELD)
    e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
    e2:SetCode(EFFECT_CANNOT_TRIGGER)
    e2:SetRange(LOCATION_ONFIELD)
    e2:SetTargetRange(0,1)
    e2:SetValue(c47510303.aclimit)
    Duel.RegisterEffect(e2,tp)
end
function c47510303.aclimit(e,re,tp)
    local loc=re:GetActivateLocation()
    return loc==LOCATION_ONFIELD and not re:GetHandler():IsImmuneToEffect(e)
end
function c47510303.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsPlayerCanDraw(tp,1) end
    Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c47510303.drop(e,tp,eg,ep,ev,re,r,rp)
    Duel.Draw(tp,1,REASON_EFFECT)
end
function c47510303.bftg(e,c)
    return c:IsAttribute(ATTRIBUTE_WATER)
end
function c47510303.bftg1(e,c)
    return c:GetAttribute()~=ATTRIBUTE_WATER
end