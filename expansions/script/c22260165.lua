--海棠于寂静中等待
function c22260165.initial_effect(c)
    --link summon
    c:EnableReviveLimit()
    aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsLinkRace,RACE_PLANT),2,2)
    --Token
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(22260165,0))
    e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOKEN)
    e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
    e1:SetProperty(EFFECT_FLAG_DELAY)
    e1:SetCode(EVENT_SUMMON_SUCCESS)
    e1:SetCountLimit(1,EFFECT_COUNT_CODE_SINGLE)
    e1:SetRange(LOCATION_MZONE)
    e1:SetCondition(c22260165.con1)
    e1:SetTarget(c22260165.tg1)
    e1:SetOperation(c22260165.op1)
    c:RegisterEffect(e1)
    local e2=e1:Clone()
    e2:SetCode(EVENT_SPSUMMON_SUCCESS)
    c:RegisterEffect(e2)
    --Attack Limit
    local e3=Effect.CreateEffect(c)
    e3:SetDescription(aux.Stringid(22260165,1))
    e3:SetType(EFFECT_TYPE_IGNITION)
    e3:SetRange(LOCATION_MZONE)
    e3:SetCountLimit(1,EFFECT_COUNT_CODE_SINGLE)
    e3:SetCost(c22260165.cost2)
    e3:SetOperation(c22260165.op2)
    c:RegisterEffect(e3)
    --to hand
    local e4=Effect.CreateEffect(c)
    e4:SetDescription(aux.Stringid(22260165,2))
    e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e4:SetType(EFFECT_TYPE_IGNITION)
    e4:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e4:SetRange(LOCATION_GRAVE)
    e4:SetCountLimit(1,EFFECT_COUNT_CODE_SINGLE)
    e4:SetCost(aux.bfgcost)
    e4:SetTarget(c22260165.tg3)
    e4:SetOperation(c22260165.op3)
    c:RegisterEffect(e4)
    local e7=Effect.CreateEffect(c)
    e7:SetType(EFFECT_TYPE_SINGLE)
    e7:SetCode(EFFECT_CANNOT_BE_XYZ_MATERIAL)
    e7:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
    e7:SetValue(c22260165.mlimit)
    c:RegisterEffect(e7)
    local e8=e7:Clone()
    e4:SetCode(EFFECT_CANNOT_BE_SYNCHRO_MATERIAL)
    c:RegisterEffect(e8)
    local e5=e7:Clone()
    e5:SetCode(EFFECT_CANNOT_BE_FUSION_MATERIAL)
    c:RegisterEffect(e5)
    local e6=e7:Clone()
    e6:SetCode(EFFECT_CANNOT_BE_LINK_MATERIAL)
    c:RegisterEffect(e6)
end
function c22260165.mlimit(e,c)
    if not c then return false end
    return c:GetAttack()~=0
end
function c22260165.con1(e,tp,eg,ep,ev,re,r,rp)
    local tc=eg:GetFirst()
    return tc:GetSummonPlayer()==tp and tc:IsFaceup() and tc:IsRace(RACE_PLANT)
end
function c22260165.tg1(e,tp,eg,ep,ev,re,r,rp,chk)
    local c=e:GetHandler()
    local zone=c:GetLinkedZone(tp)
    local g=c:GetLinkedGroup()
    local ft=Duel.GetMZoneCount(tp,g,tp,LOCATION_REASON_TOFIELD,zone)
    if chk==0 then return ft>0 and Duel.IsPlayerCanSpecialSummonMonster(tp,22269989,nil,0x4011,0,0,1,RACE_PLANT,ATTRIBUTE_EARTH,zone)end
    Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,1,0,0)
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,0,0,0)
end 
function c22260165.op1(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local zone=c:GetLinkedZone(tp)
    local g=c:GetLinkedGroup()
    local ft=Duel.GetMZoneCount(tp,g,tp,LOCATION_REASON_TOFIELD,zone)
    if ft<1 then return end
    if not Duel.IsPlayerCanSpecialSummonMonster(tp,22269989,nil,0x4011,0,0,1,RACE_PLANT,ATTRIBUTE_EARTH,zone) then return end
    local token=Duel.CreateToken(tp,22269989)
    Duel.SpecialSummon(token,0,tp,tp,false,false,POS_FACEUP,zone)
end
function c22260165.cost2(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return e:GetHandler():IsReleasable() end
    Duel.Release(e:GetHandler(),REASON_COST)
end
function c22260165.op2(e,tp,eg,ep,ev,re,r,rp)
    --cannot attack
    local e1=Effect.CreateEffect(e:GetHandler())
    e1:SetType(EFFECT_TYPE_FIELD)
    e1:SetCode(EFFECT_CANNOT_ATTACK)
    e1:SetTargetRange(0,LOCATION_MZONE)
    e1:SetReset(RESET_PHASE+PHASE_END,2)
    Duel.RegisterEffect(e1,tp)
end
function c22260165.filter3(c,e,tp)
    return c:IsCanBeSpecialSummoned(e,0,tp,false,false) and c:IsRace(RACE_PLANT)
end
function c22260165.tg3(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return chkc:IsLocation(LOCATION_GRAVE) and c22260165.filter3(chkc,e,tp) end
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
        and Duel.IsExistingTarget(c22260165.filter3,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,e:GetHandler(),e,tp) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
    local g=Duel.SelectTarget(tp,c22260165.filter3,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,1,e:GetHandler(),e,tp)
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function c22260165.op3(e,tp,eg,ep,ev,re,r,rp)
    local tc=Duel.GetFirstTarget()
    if tc:IsRelateToEffect(e) then
        Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
    end
end