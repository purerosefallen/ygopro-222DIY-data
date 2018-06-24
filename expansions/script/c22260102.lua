--樱与刃与结缘的他
local m=22260102
local cm=_G["c"..m]
function cm.initial_effect(c)
    --fusion material
    c:EnableReviveLimit()
    aux.AddFusionProcFunRep(c,aux.FilterBoolFunction(c22260102.mfilter),2,true)
    --spsummon condition
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
    e1:SetCode(EFFECT_SPSUMMON_CONDITION)
    e1:SetValue(c22260102.splimit)
    c:RegisterEffect(e1)
    --special summon rule
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_FIELD)
    e2:SetCode(EFFECT_SPSUMMON_PROC)
    e2:SetProperty(EFFECT_FLAG_UNCOPYABLE)
    e2:SetRange(LOCATION_EXTRA)
    e2:SetCondition(c22260102.sprcon)
    e2:SetOperation(c22260102.sprop)
    c:RegisterEffect(e2)
    --ToGrave
    local e3=Effect.CreateEffect(c)
    e3:SetDescription(aux.Stringid(22260102,0))
    e3:SetCategory(CATEGORY_TOGRAVE)
    e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e3:SetProperty(EFFECT_FLAG_DELAY)
    e3:SetCode(EVENT_SPSUMMON_SUCCESS)
    e3:SetCondition(c22260102.comcon)
    e3:SetTarget(c22260102.tgtg)
    e3:SetOperation(c22260102.tgop)
    c:RegisterEffect(e3)
    --Destory
    local e4=Effect.CreateEffect(c)
    e4:SetDescription(aux.Stringid(22260102,1))
    e4:SetCategory(CATEGORY_DESTROY)
    e4:SetType(EFFECT_TYPE_QUICK_O)
    e4:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e4:SetCode(EVENT_FREE_CHAIN)
    e4:SetRange(LOCATION_MZONE)
    e4:SetCountLimit(1)
    e4:SetHintTiming(0,0x1e0)
    e4:SetCondition(c22260102.comcon)
    e4:SetTarget(c22260102.destg)
    e4:SetOperation(c22260102.desop)
    c:RegisterEffect(e4)
    --Control
    local e5=Effect.CreateEffect(c)
    e5:SetDescription(aux.Stringid(22260102,2))
    e5:SetCategory(CATEGORY_CONTROL)
    e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e5:SetCode(EVENT_BATTLE_START)
    e5:SetCondition(c22260102.comcon)
    e5:SetTarget(c22260102.cttg)
    e5:SetOperation(c22260102.ctop)
    c:RegisterEffect(e5)
    --token
    local e6=Effect.CreateEffect(c)
    e6:SetDescription(aux.Stringid(22260102,0))
    e6:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOKEN)
    e6:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e6:SetProperty(EFFECT_FLAG_DELAY)
    e6:SetCode(EVENT_TO_GRAVE)
    e1:SetCondition(c22260102.comcon)
    e6:SetTarget(c22260102.tg2)
    e6:SetOperation(c22260102.op2)
    c:RegisterEffect(e6)
    --xyzlimit
    local e10=Effect.CreateEffect(c)
    e10:SetType(EFFECT_TYPE_SINGLE)
    e10:SetCode(EFFECT_CANNOT_BE_XYZ_MATERIAL)
    e10:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
    e10:SetValue(c22260102.mlimit)
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
function c22260102.mlimit(e,c)
    if not c then return false end
    return c:GetAttack()~=0
end
--
function c22260102.comfilter(c)
    return c:GetBaseAttack()~=0
end 
function c22260102.comcon(e)
    return not Duel.IsExistingMatchingCard(c22260102.comfilter,e:GetHandlerPlayer(),LOCATION_ONFIELD,0,1,e:GetHandler())
end
--
function c22260102.mfilter(c)
    return c:IsRace(RACE_PLANT) and c:IsCanBeFusionMaterial()
end
function c22260102.splimit(e,se,sp,st)
    return e:GetHandler():GetLocation()~=LOCATION_EXTRA
end
function c22260102.spfilter(c)
    return c:IsRace(RACE_PLANT) and c:IsCanBeFusionMaterial() and c:IsAbleToDeckOrExtraAsCost()
end
function c22260102.spfilter1(c,tp,g)
    return g:IsExists(c22260102.spfilter2,1,c,tp,c)
end
function c22260102.spfilter2(c,tp,mc)
    return Duel.GetLocationCountFromEx(tp,tp,Group.FromCards(c,mc))>0
end
function c22260102.sprcon(e,c)
    if not Duel.IsExistingMatchingCard(c22260018.comfilter,e:GetHandlerPlayer(),LOCATION_ONFIELD,0,1,e:GetHandler()) then return end
    if c==nil then return true end
    local tp=c:GetControler()
    local g=Duel.GetMatchingGroup(c22260102.spfilter,tp,LOCATION_MZONE,0,nil)
    return g:IsExists(c22260102.spfilter1,1,nil,tp,g)
end
function c22260102.sprop(e,tp,eg,ep,ev,re,r,rp,c)
    local g=Duel.GetMatchingGroup(c22260102.spfilter,tp,LOCATION_MZONE,0,nil)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
    local g1=g:FilterSelect(tp,c22260102.spfilter1,1,1,nil,tp,g)
    local mc=g1:GetFirst()
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
    local g2=g:FilterSelect(tp,c22260102.spfilter2,1,1,mc,tp,mc)
    g1:Merge(g2)
    Duel.SendtoGrave(g1,REASON_COST)
end
--
function c22260102.tgfilter(c)
    return c:IsType(TYPE_MONSTER) and c:IsRace(RACE_PLANT) and c:IsAbleToGrave()
end
function c22260102.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c22260102.tgfilter,tp,LOCATION_DECK,0,1,nil) end
    Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
end
function c22260102.tgop(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
    local g=Duel.SelectMatchingCard(tp,c22260102.tgfilter,tp,LOCATION_DECK,0,1,1,nil)
    if g:GetCount()>0 then
        Duel.SendtoGrave(g,REASON_EFFECT)
    end
end
--
function c22260102.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return chkc:IsOnField() and chkc:IsFaceup() end
    if chk==0 then return Duel.IsExistingTarget(nil,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
    Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
    local g=Duel.SelectTarget(tp,nil,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
    Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c22260102.desop(e,tp,eg,ep,ev,re,r,rp)
    local tc=Duel.GetFirstTarget()
    if tc:IsRelateToEffect(e) then
        Duel.Destroy(tc,REASON_EFFECT)
    end
end
--
function c22260102.cttg(e,tp,eg,ep,ev,re,r,rp,chk)
    local tc=e:GetHandler():GetBattleTarget()
    if chk==0 then return tc and tc:IsRelateToBattle() and tc:IsControlerCanBeChanged() end
    Duel.SetOperationInfo(0,CATEGORY_CONTROL,tc,1,0,0)
end
function c22260102.ctop(e,tp,eg,ep,ev,re,r,rp)
    local tc=e:GetHandler():GetBattleTarget()
    if tc:IsRelateToBattle() then
        Duel.GetControl(tc,tp,PHASE_END,1)
    end
end
--
function c22260102.tg2(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
       and Duel.IsPlayerCanSpecialSummonMonster(tp,22269993,nil,0x4011,0,0,1,RACE_PLANT,ATTRIBUTE_EARTH) end
    Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,1,0,0)
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,0)
    end
function c22260102.op2(e,tp,eg,ep,ev,re,r,rp)
    if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
    if Duel.IsPlayerCanSpecialSummonMonster(tp,22269993,nil,0x4011,0,0,1,RACE_PLANT,ATTRIBUTE_EARTH) then
    local token=Duel.CreateToken(tp,22269993)
    Duel.SpecialSummon(token,0,tp,tp,false,false,POS_FACEUP)
    end
end