--玻离之物 垃圾
local m=62200002
local cm=_G["c"..m]
xpcall(function() require("expansions/script/c62200000") end,function() require("script/c62200000") end)
cm.named_with_FragileArticles=true
--
function c62200002.initial_effect(c)
    --tograve
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(62200002,0))
    e1:SetCategory(CATEGORY_TOGRAVE)
    e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
    e1:SetCode(EVENT_TO_GRAVE)
    e1:SetCost(c62200002.cost)
    e1:SetTarget(c62200002.tgtg)
    e1:SetOperation(c62200002.tgop)
    c:RegisterEffect(e1)
    --spsummon
    --local e2=Effect.CreateEffect(c)
    --e2:SetDescription(aux.Stringid(62200002,1))
    --e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
    --e2:SetType(EFFECT_TYPE_IGNITION)
    --e2:SetCode(EVENT_FREE_CHAIN)
    --e2:SetRange(LOCATION_GRAVE)
    --e2:SetCost(c62200002.cost)
    --e2:SetCondition(c62200002.spcon)
    --e2:SetTarget(c62200002.sptg)
    --e2:SetOperation(c62200002.spop)
    --c:RegisterEffect(e2)
    --xyzlimit
    local e10=Effect.CreateEffect(c)
    e10:SetType(EFFECT_TYPE_SINGLE)
    e10:SetCode(EFFECT_CANNOT_BE_XYZ_MATERIAL)
    e10:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
    e10:SetValue(c62200002.mlimit)
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
function c62200002.mlimit(e,c)
    if not c then return false end
    return c:GetAttack()~=0
end    
--
function c62200002.cost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.CheckLPCost(tp,1000) end
    Duel.PayLPCost(tp,1000)
end
--
function c62200002.tgfilter(c)
    return c:IsCode(62200002) and c:IsAbleToGrave()
end
function c62200002.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c62200002.tgfilter,tp,LOCATION_DECK,0,1,nil) end
    Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
end
function c62200002.tgop(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
    local g=Duel.SelectMatchingCard(tp,c62200002.tgfilter,tp,LOCATION_DECK,0,1,1,nil)
    if g:GetCount()>0 then
        Duel.SendtoGrave(g,REASON_EFFECT)
    end
end
--
--function c62200002.spcon(e,tp,eg,ep,ev,re,r,rp)
    --return Duel.GetLP(tp)<Duel.GetLP(1-tp)
--end
--function c62200002.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
    --if chk==0 then return e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
    --Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
--end
--function c62200002.spop(e,tp,eg,ep,ev,re,r,rp)
    --local c=e:GetHandler()
    --if c:IsRelateToEffect(e) then 
        --Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
    --end
--end