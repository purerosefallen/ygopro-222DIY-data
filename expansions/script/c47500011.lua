--机械师 姬塔
function c47500011.initial_effect(c)
    --pendulum summon
    aux.EnablePendulumAttribute(c)  
    --pendulum produce
    local e1=Effect.CreateEffect(c)
    e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
    e1:SetType(EFFECT_TYPE_IGNITION)
    e1:SetRange(LOCATION_PZONE)
    e1:SetCountLimit(1,47500011)
    e1:SetCondition(c47500011.pencon)
    e1:SetTarget(c47500011.pentg)
    e1:SetOperation(c47500011.penop)
    c:RegisterEffect(e1) 
    --special summon
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_FIELD)
    e2:SetCode(EFFECT_SPSUMMON_PROC)
    e2:SetProperty(EFFECT_FLAG_UNCOPYABLE)
    e2:SetRange(LOCATION_HAND)
    e2:SetCountLimit(1,47500010+EFFECT_COUNT_CODE_DUEL)
    e2:SetCondition(c47500011.spcon)
    e2:SetOperation(c47500011.spop)
    c:RegisterEffect(e2)  
    --race machine
    local e4=Effect.CreateEffect(c)
    e4:SetType(EFFECT_TYPE_SINGLE)
    e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e4:SetCode(EFFECT_ADD_RACE)
    e4:SetRange(LOCATION_MZONE)
    e4:SetValue(RACE_MACHINE)
    c:RegisterEffect(e4)
    local e3=Effect.CreateEffect(c)
    e3:SetType(EFFECT_TYPE_FIELD)
    e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e3:SetCode(EFFECT_ADD_TYPE)
    e3:SetTargetRange(LOCATION_MZONE,0)
    e3:SetTarget(c47500011.indtg)
    e3:SetRange(LOCATION_MZONE)
    e3:SetValue(TYPE_TUNER)
    c:RegisterEffect(e3)    
end
c47500011.card_code_list={47500000}
function c47500011.spcon(e,c)
    if c==nil then return true end
    local tp=c:GetControler()
    return Duel.GetLocationCount(tp,LOCATION_MZONE)>=2 and Duel.IsPlayerCanSpecialSummonCount(tp,1) and Duel.IsPlayerCanSpecialSummonMonster(tp,47500012,0,0x4011,100,100,1,RACE_MACHINE,ATTRIBUTE_DARK)
end
function c47500011.spop(e,tp,eg,ep,ev,re,r,rp,c)
    local c=e:GetHandler()
    if Duel.IsPlayerCanSpecialSummonMonster(tp,47500012,0,0x4011,100,100,1,RACE_MACHINE,ATTRIBUTE_DARK) then
        local token=Duel.CreateToken(tp,47500012)
        local e1=Effect.CreateEffect(c)
        e1:SetType(EFFECT_TYPE_SINGLE)
        e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
        e1:SetCode(EFFECT_CANNOT_BE_LINK_MATERIAL)
        e1:SetValue(1)
        token:RegisterEffect(e1,true)
        Duel.SpecialSummonStep(token,0,tp,tp,false,false,POS_FACEUP)
    end
    Duel.SpecialSummonComplete()
end
function c47500011.pencon(e,tp,eg,ep,ev,re,r,rp)
    return not Duel.IsExistingMatchingCard(nil,tp,LOCATION_PZONE,0,1,e:GetHandler())
end
function c47500011.penfilter(c)
    return aux.IsCodeListed(c,47500000) and c:IsType(TYPE_PENDULUM) and not c:IsForbidden()
end
function c47500011.pentg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return e:GetHandler():IsDestructable() and Duel.IsExistingMatchingCard(c47500011.penfilter,tp,LOCATION_EXTRA,0,1,nil)end
end
function c47500011.penop(e,tp,eg,ep,ev,re,r,rp)
    if not e:GetHandler():IsRelateToEffect(e) then return end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
    local g=Duel.SelectMatchingCard(tp,c47500011.penfilter,tp,LOCATION_EXTRA,0,1,1,nil)
    local tc=g:GetFirst()
    if tc then
        Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
        local e1=Effect.CreateEffect(c)
        e1:SetType(EFFECT_TYPE_SINGLE)
        e1:SetCode(EFFECT_LEAVE_FIELD_REDIRECT)
        e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
        e1:SetReset(RESET_EVENT+RESETS_REDIRECT)
        e1:SetValue(LOCATION_DECK)
        tc:RegisterEffect(e1)
    end
end
function c47500011.indtg(e,c)
    return c:IsType(TYPE_TOKEN) and c:IsRace(RACE_MACHINE)
end