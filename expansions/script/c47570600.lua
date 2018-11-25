--塞雷斯特·马格纳
function c47570600.initial_effect(c)
    --xyz summon
    c:EnableReviveLimit()
    aux.AddXyzProcedureLevelFree(c,c47570600.mfilter,c47570600.xyzcheck,3,3)   
    --
    local e1=Effect.CreateEffect(c)
    
    e1:SetType(EFFECT_TYPE_QUICK_O)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetRange(LOCATION_MZONE)
    e1:SetCost(c47570600.cost)
    e1:SetTarget(c47570600.xyztg)
    e1:SetOperation(c47570600.xyzop)
    c:RegisterEffect(e1)
    --race
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_FIELD)
    e2:SetRange(LOCATION_FZONE)
    e2:SetTargetRange(LOCATION_MZONE+LOCATION_GRAVE,LOCATION_MZONE+LOCATION_GRAVE)
    e2:SetCode(EFFECT_CHANGE_RACE)
    e2:SetValue(RACE_ZOMBIE)
    c:RegisterEffect(e2)
    --summon limit
    local e3=Effect.CreateEffect(c)
    e3:SetType(EFFECT_TYPE_FIELD)
    e3:SetRange(LOCATION_FZONE)
    e3:SetCode(EFFECT_CANNOT_SUMMON)
    e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
    e3:SetTargetRange(1,1)
    e3:SetTarget(c47570600.sumlimit)
    c:RegisterEffect(e3)
    local e4=e3:Clone()
    e4:SetCode(EFFECT_CANNOT_MSET)
    c:RegisterEffect(e4)
    --effect gian
    local e5=Effect.CreateEffect(c)
    e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
    e5:SetCode(EVENT_ADJUST)
    e5:SetRange(LOCATION_MZONE)
    e5:SetOperation(c47570600.efop)
    c:RegisterEffect(e5)
    --baseatk
    local e6=Effect.CreateEffect(c)
    e6:SetType(EFFECT_TYPE_SINGLE)
    e6:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e6:SetRange(LOCATION_MZONE)
    e6:SetCode(EFFECT_SET_BASE_ATTACK)
    e6:SetValue(c47570600.atkval)
    c:RegisterEffect(e6)
    local e7=e6:Clone()
    e7:SetCode(EFFECT_SET_BASE_DEFENSE)
    e7:SetValue(c47570600.defval)
    c:RegisterEffect(e7)
    --pendulum
    local e8=Effect.CreateEffect(c)
    e8:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e8:SetCode(EVENT_LEAVE_FIELD)
    e8:SetProperty(EFFECT_FLAG_DELAY)
    e8:SetCondition(c47570600.tpcon)
    e8:SetTarget(c47570600.tptg)
    e8:SetOperation(c47570600.tpop)
    c:RegisterEffect(e8)  
end
function c47570600.mfilter(c,xyzc)
    return c:IsRace(RACE_ZOMBIE) or c:IsAttribute(ATTRIBUTE_DARK)
end
function c47570600.xyzcheck(g)
    return g:GetClassCount(Card.GetDefense)==1
end
function c47570600.sumlimit(e,c,tp,sumtp)
    return bit.band(sumtp,SUMMON_TYPE_ADVANCE)==SUMMON_TYPE_ADVANCE and c:GetRace()~=RACE_ZOMBIE
end
function c47570600.cost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,2,REASON_COST) end
    e:GetHandler():RemoveOverlayCard(tp,2,2,REASON_COST)
end
function c47570600.filter(c,tp)
    return c:IsRace(RACE_ZOMBIE) and not c:IsType(TYPE_TOKEN)
        and (c:IsControler(tp) or c:IsAbleToChangeControler()) and c:IsFaceup()
end
function c47570600.xyztg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return chkc:IsLocation(LOCATION_MZONE) and c47570600.filter(chkc,tp) and chkc~=e:GetHandler() end
    if chk==0 then return e:GetHandler():IsType(TYPE_XYZ)
        and Duel.IsExistingTarget(c47570600.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,e:GetHandler(),tp) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
    Duel.SelectTarget(tp,c47570600.filter,tp,LOCATION_ONFIELD+LOCATION_EXTRA,LOCATION_ONFIELD+LOCATION_MZONE,1,1,e:GetHandler(),tp)
end
function c47570600.xyzop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local tc=Duel.GetFirstTarget()
    if c:IsRelateToEffect(e) and tc:IsRelateToEffect(e) and not tc:IsImmuneToEffect(e) then
        local og=tc:GetOverlayGroup()
        if og:GetCount()>0 then
            Duel.SendtoGrave(og,REASON_RULE)
        end
        Duel.Overlay(c,Group.FromCards(tc))
    end
end
function c47570600.effilter(c)
    return c:IsType(TYPE_MONSTER)
end
function c47570600.efop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()  
    local ct=c:GetOverlayGroup(tp,1,0)
    local wg=ct:Filter(c47570600.effilter,nil,tp)
    local wbc=wg:GetFirst()
    while wbc do
        local code=wbc:GetOriginalCode()
        local e1=Effect.CreateEffect(c)
        e1:SetType(EFFECT_TYPE_SINGLE)
        e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
        e1:SetCode(EFFECT_ADD_CODE)
        e1:SetValue(code)
        e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
        c:RegisterEffect(e1)
        if c:IsFaceup() and c:GetFlagEffect(code)==0 then
        c:CopyEffect(code, RESET_EVENT+0x1fe0000+EVENT_CHAINING, 1)
        c:RegisterFlagEffect(code,RESET_EVENT+0x1fe0000+EVENT_CHAINING,0,1)  
        end 
        wbc=wg:GetNext()
    end  
end
function c47570600.atkfilter(c)
    return c:IsType(TYPE_MONSTER) and c:GetAttack()>=0
end
function c47570600.atkval(e,c)
    local g=e:GetHandler():GetOverlayGroup():Filter(c47570600.atkfilter,nil)
    return g:GetSum(Card.GetAttack)
end
function c47570600.deffilter(c)
    return c:IsType(TYPE_MONSTER) and c:GetDefense()>=0
end
function c47570600.defval(e,c)
    local g=e:GetHandler():GetOverlayGroup():Filter(c47570600.deffilter,nil)
    return g:GetSum(Card.GetDefense)
end
function c47570600.tpcon(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    return c:IsPreviousLocation(LOCATION_MZONE) and c:IsFaceup()
end
function c47570600.tptg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1) end
end
function c47570600.tpop(e,tp,eg,ep,ev,re,r,rp)
    if not Duel.CheckLocation(tp,LOCATION_PZONE,0) and not Duel.CheckLocation(tp,LOCATION_PZONE,1) then return false end
    local c=e:GetHandler()
    if c:IsRelateToEffect(e) then
        Duel.MoveToField(c,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
    end
end