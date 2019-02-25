--魔王的星晶兽 撒旦
function c47510666.initial_effect(c)
    --link summon
    aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsAttribute,ATTRIBUTE_DARK),3,4,c47510666.lcheck)
    c:EnableReviveLimit()
    --duel dragon
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(47510666,0))
    e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOKEN)
    e1:SetType(EFFECT_TYPE_QUICK_O)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetRange(LOCATION_MZONE)
    e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e1:SetCountLimit(1,47510666)
    e1:SetHintTiming(0,TIMING_MAIN_END)
    e1:SetCondition(c47510666.spcon)
    e1:SetTarget(c47510666.sptg)
    e1:SetOperation(c47510666.spop)
    c:RegisterEffect(e1) 
    --remove
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(47510666,1))
    e2:SetCategory(CATEGORY_TOHAND)
    e2:SetType(EFFECT_TYPE_QUICK_O)
    e2:SetCode(EVENT_FREE_CHAIN)
    e2:SetRange(LOCATION_MZONE)
    e2:SetCountLimit(1,47510666)
    e2:SetTarget(c47510666.rmtg)
    e2:SetOperation(c47510666.rmop)
    c:RegisterEffect(e2)   
end
function c47510666.lcheck(g,lc)
    return g:IsExists(Card.IsRace,1,nil,RACE_FIEND)
end
function c47510666.spcon(e)
    return e:GetHandler():IsSummonType(SUMMON_TYPE_LINK)
end
function c47510666.rmfilter(c)
    return c:IsAbleToRemove()
end
function c47510666.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    local zone=bit.band(e:GetHandler():GetLinkedZone(tp),0x1f)
    if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(1-tp) and c47510666.rmfilter(chkc) end
    if chk==0 then return Duel.IsExistingTarget(c47510666.rmfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,e:GetHandler()) and Duel.GetLocationCount(tp,LOCATION_MZONE,tp,LOCATION_REASON_TOFIELD,zone)>0 and zone~=0 end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
    local g=Duel.SelectTarget(tp,c47510666.rmfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,e:GetHandler())
    Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,1,0,0)
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,0)
    Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,1,0,0)
end
function c47510666.spop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local tc=Duel.GetFirstTarget()
    local zone=bit.band(c:GetLinkedZone(tp),0x1f)
    local atk=tc:GetTextAttack()
    local def=tc:GetTextDefense()
    local lv=tc:GetOriginalLevel()
    local race=tc:GetOriginalRace()
    local att=tc:GetOriginalAttribute()
    local code=tc:GetOriginalCode()
    if Duel.GetLocationCount(tp,LOCATION_MZONE,tp,LOCATION_REASON_TOFIELD,zone)<=0
        or not Duel.IsPlayerCanSpecialSummonMonster(tp,47511666,0,0x4011,atk,def,lv,race,att) then return end
    local token=Duel.CreateToken(tp,47511666)
    if tc:IsRelateToEffect(e) and Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)~=0 and Duel.SpecialSummonStep(token,0,tp,tp,false,false,POS_FACEUP,zone) then
        local e1=Effect.CreateEffect(c)
        e1:SetType(EFFECT_TYPE_SINGLE)
        e1:SetCode(EFFECT_SET_BASE_ATTACK)
        e1:SetValue(atk)
        e1:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TOFIELD)
        token:RegisterEffect(e1)
        local e2=Effect.CreateEffect(c)
        e2:SetType(EFFECT_TYPE_SINGLE)
        e2:SetCode(EFFECT_SET_BASE_DEFENSE)
        e2:SetValue(def)
        e2:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TOFIELD)
        token:RegisterEffect(e2)
        local e3=Effect.CreateEffect(c)
        e3:SetType(EFFECT_TYPE_SINGLE)
        e3:SetCode(EFFECT_CHANGE_ATTRIBUTE)
        e3:SetValue(att)
        token:RegisterEffect(e3)
        local e4=Effect.CreateEffect(c)
        e4:SetType(EFFECT_TYPE_SINGLE)
        e4:SetCode(EFFECT_CHANGE_LEVEL)
        e4:SetValue(lv)
        token:RegisterEffect(e4)
        local e5=Effect.CreateEffect(c)
        e5:SetType(EFFECT_TYPE_SINGLE)
        e5:SetCode(EFFECT_CHANGE_RACE)
        e5:SetValue(race)
        token:RegisterEffect(e5)
        token:CopyEffect(code,RESET_EVENT+RESETS_STANDARD,1)
        Duel.SpecialSummonComplete()
    end
end
function c47510666.rmtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(aux.TRUE,tp,LOCATION_REMOVED,LOCATION_REMOVED,1,nil,e,tp) end
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_REMOVED)
end
function c47510666.rmop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local g=Duel.GetFieldGroup(tp,LOCATION_REMOVED,LOCATION_REMOVED):RandomSelect(tp,1)
    local tc=g:GetFirst()
    if Duel.SendtoHand(tc,tp,REASON_EFFECT)~=0 then
        Duel.ConfirmCards(1-tp,tc)
        Duel.BreakEffect()
        if tc:IsType(TYPE_EFFECT) and tc:IsType(TYPE_MONSTER) then
        local f=Card.RegisterEffect
        Card.RegisterEffect=function(tc,e,forced)
            if e:GetRange(LOCATION_PZONE) then
                e:SetRange((e:GetRange()-LOCATION_PZONE | LOCATION_MZONE))
            end
            f(tc,e,forced)
        end
        local code=tc:GetOriginalCode()
        c:CopyEffect(code,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,1)
        Duel.ConfirmCards(1-tp,tc)
        Card.RegisterEffect=f
        local code=tc:GetOriginalCodeRule()
        local e1=Effect.CreateEffect(c)
        e1:SetType(EFFECT_TYPE_SINGLE)
        e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
        e1:SetCode(EFFECT_CHANGE_CODE)
        e1:SetValue(code)
        e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
        c:RegisterEffect(e1)
        end
    end
end