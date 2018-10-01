--玻离之物 尽头
local m=62200001
local cm=_G["c"..m]
xpcall(function() require("expansions/script/c62200000")end,function() require("script/c62200000") end)
cm.named_with_FragileArticles=true
--
function c62200001.initial_effect(c)
    --tograve
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(62200001,0))
    e1:SetType(EFFECT_TYPE_TRIGGER_F+EFFECT_TYPE_SINGLE)
    e1:SetCode(EVENT_SUMMON_SUCCESS)
    e1:SetCost(c62200001.cost)
    e1:SetTarget(c62200001.tgtg)
    e1:SetOperation(c62200001.tgop)
    c:RegisterEffect(e1)
    local e2=e1:Clone()
    e2:SetCode(EVENT_SPSUMMON_SUCCESS)
    c:RegisterEffect(e2)
    --search
    local e3=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(62200001,1))
    e3:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
    e3:SetType(EFFECT_TYPE_IGNITION)
    e3:SetRange(LOCATION_MZONE)
    e3:SetCode(EVENT_FREE_CHAIN)
    e3:SetCountLimit(1)
    e3:SetCost(c62200001.cost)
    e3:SetCondition(c62200001.secon)
    e3:SetTarget(c62200001.setg)
    e3:SetOperation(c62200001.seop)
    c:RegisterEffect(e3)
    --xyzlimit
    local e10=Effect.CreateEffect(c)
    e10:SetType(EFFECT_TYPE_SINGLE)
    e10:SetCode(EFFECT_CANNOT_BE_XYZ_MATERIAL)
    e10:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
    e10:SetValue(c62200001.mlimit)
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
function c62200001.mlimit(e,c)
    if not c then return false end
    return c:GetAttack()~=0
end
--
function c62200001.cost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.CheckLPCost(tp,1000) end
    Duel.PayLPCost(tp,1000)
end
--
function c62200001.tgfilter(c)
    return c:IsType(TYPE_MONSTER) and c:GetBaseAttack()==0 and c:IsAbleToGrave()
end
function c62200001.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c62200001.tgfilter,tp,LOCATION_DECK,0,1,nil) end
    Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
end
function c62200001.tgop(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
    local g=Duel.SelectMatchingCard(tp,c62200001.tgfilter,tp,LOCATION_DECK,0,1,1,nil)
    if g:GetCount()>0 then
        Duel.SendtoGrave(g,REASON_EFFECT)
    end
end
--
function c62200001.mlimit(e,c)
    if not c then return false end
    return c:GetAttack()~=0
end
--
function c62200001.secon(e,tp,eg,ep,ev,re,r,rp)
    return Duel.GetLP(tp)<Duel.GetLP(1-tp)
end
function c62200001.sefilter(c)
    return baka.check_set_FragileLyric(c) and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsAbleToHand()
end
function c62200001.setg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c62200001.sefilter,tp,LOCATION_DECK,0,1,nil) end
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c62200001.seop(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
    local g=Duel.SelectMatchingCard(tp,c62200001.sefilter,tp,LOCATION_DECK,0,1,1,nil)
    if g:GetCount()>0 then
        Duel.SendtoHand(g,nil,REASON_EFFECT)
        Duel.ConfirmCards(1-tp,g)
    end
end