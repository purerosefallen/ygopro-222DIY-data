--赤百合与骷髅与初梦的他
local m=22260017
local cm=_G["c"..m]
function cm.initial_effect(c)
    --Token&Recover
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(22260017,0))
    e1:SetCategory(CATEGORY_TOKEN+CATEGORY_RECOVER)
    e1:SetType(EFFECT_TYPE_IGNITION)
    e1:SetRange(LOCATION_HAND)
    e1:SetCondition(c22260017.comcon)
    e1:SetCost(c22260017.cost)
    e1:SetTarget(c22260017.target)
    e1:SetOperation(c22260017.operation)
    c:RegisterEffect(e1)
    --SpecialSummon
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(22260017,1))
    e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e2:SetType(EFFECT_TYPE_IGNITION)
    e2:SetRange(LOCATION_HAND)
    e2:SetCondition(c22260017.comcon)
    e2:SetCost(c22260017.cost)
    e2:SetTarget(c22260017.sptg)
    e2:SetOperation(c22260017.spop)
    c:RegisterEffect(e2)
    --pos
    local e3=Effect.CreateEffect(c)
    e3:SetDescription(aux.Stringid(22260017,2))
    e3:SetCategory(CATEGORY_POSITION)
    e3:SetType(EFFECT_TYPE_QUICK_O)
    e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e3:SetRange(LOCATION_HAND)
    e3:SetCode(EVENT_FREE_CHAIN)
    e3:SetCondition(c22260017.comcon)
    e3:SetCost(c22260017.cost)
    e3:SetTarget(c22260017.postg)
    e3:SetOperation(c22260017.posop)
    c:RegisterEffect(e3)
    --xyzlimit
    local e10=Effect.CreateEffect(c)
    e10:SetType(EFFECT_TYPE_SINGLE)
    e10:SetCode(EFFECT_CANNOT_BE_XYZ_MATERIAL)
    e10:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
    e10:SetValue(c22260017.mlimit)
    c:RegisterEffect(e10)
    local e11=e10:Clone()
    e11:SetCode(EFFECT_CANNOT_BE_SYNCHRO_MATERIAL)
    c:RegisterEffect(e11)
    local e12=e10:Clone()
    e12:SetCode(EFFECT_CANNOT_BE_FUSION_MATERIAL)
    c:RegisterEffect(e12)
    local e13=e10:Clone()
    e13:SetCode(EFFECT_CANNOT_BE_LINK_MATERIAL)
    c:RegisterEffect(e13)
end

--
function c22260017.mlimit(e,c)
    if not c then return false end
    return c:GetAttack()~=0
end
--
function c22260017.comfilter(c)
    return c:GetBaseAttack()~=0
end 
function c22260017.comcon(e)
    return not Duel.IsExistingMatchingCard(c22260017.comfilter,e:GetHandlerPlayer(),LOCATION_ONFIELD,0,1,e:GetHandler())
end
--
function c22260017.cost(e,tp,eg,ep,ev,re,r,rp,chk)
    local c=e:GetHandler()
    if chk==0 then return c:IsDiscardable() end
    Duel.SendtoGrave(c,REASON_COST+REASON_DISCARD)
end
--
function c22260017.target(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
       and Duel.IsPlayerCanSpecialSummonMonster(tp,22269994,nil,0x4011,0,0,1,RACE_PLANT,ATTRIBUTE_EARTH) end
    Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,1,0,0)
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,0)
    end
function c22260017.operation(e,tp,eg,ep,ev,re,r,rp)
    if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
    if Duel.IsPlayerCanSpecialSummonMonster(tp,22269994,nil,0x4011,0,0,1,RACE_PLANT,ATTRIBUTE_EARTH) then
    local token=Duel.CreateToken(tp,22269994)
    Duel.SpecialSummon(token,0,tp,tp,false,false,POS_FACEUP)
        Duel.BreakEffect()
        Duel.Recover(tp,500,REASON_EFFECT)
    end
end
--
function c22260017.filter(c,e,tp)
    return c:IsCanBeSpecialSummoned(e,0,tp,false,false) and c:GetAttack()==0
end
function c22260017.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return chkc:IsLocation(LOCATION_GRAVE) and c22260017.filter(chkc,e,tp) end
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
        and Duel.IsExistingTarget(c22260017.filter,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,nil,e,tp) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
    local g=Duel.SelectTarget(tp,c22260017.filter,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,1,nil,e,tp)
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function c22260017.spop(e,tp,eg,ep,ev,re,r,rp)
    local tc=Duel.GetFirstTarget()
    if tc:IsRelateToEffect(e) then
        Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
    end
end
--
function c22260017.setfilter(c)
    return c:IsFaceup() and c:IsCanTurnSet()
end
function c22260017.postg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return chkc:IsLocation(LOCATION_MZONE) and c22260017.setfilter(chkc) and chkc~=e:GetHandler() end
    if chk==0 then return Duel.IsExistingTarget(c22260017.setfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,e:GetHandler()) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_POSCHANGE)
    local g=Duel.SelectTarget(tp,c22260017.setfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,e:GetHandler())
    Duel.SetOperationInfo(0,CATEGORY_POSITION,g,1,0,0)
end
function c22260017.posop(e,tp,eg,ep,ev,re,r,rp)
    local tc=Duel.GetFirstTarget()
    if tc:IsFaceup() and tc:IsRelateToEffect(e) then
        Duel.ChangePosition(tc,POS_FACEDOWN_DEFENSE)
    end
end