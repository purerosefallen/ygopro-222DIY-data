--玻离之物 哭泣骷髅
local m=62200003
local cm=_G["c"..m]
xpcall(function() require("expansions/script/c62200000")end,function() require("script/c62200000") end)
cm.named_with_FragileArticles=true
--
function c62200003.initial_effect(c)
    --spsummon
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(62200003,0))
    e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
    e1:SetCode(EVENT_SUMMON_SUCCESS)
    e1:SetRange(LOCATION_HAND)
    e1:SetCost(c62200003.cost)
    e1:SetCondition(c62200003.spcon)
    e1:SetTarget(c62200003.sptg)
    e1:SetOperation(c62200003.spop)
    c:RegisterEffect(e1)
    local e2=e1:Clone()
    e2:SetCode(EVENT_SPSUMMON_SUCCESS)
    c:RegisterEffect(e2)
    --search
    local e3=Effect.CreateEffect(c)
    e3:SetDescription(aux.Stringid(62200003,1))
    e3:SetCategory(CATEGORY_TOHAND+CATEGORY_DRAW)
    e3:SetType(EFFECT_TYPE_IGNITION)
    e3:SetRange(LOCATION_HAND)
    e3:SetCondition(c62200003.dwcon)
    e3:SetCost(c62200003.dwcost)
    e3:SetTarget(c62200003.dwtg)
    e3:SetOperation(c62200003.dwop)
    c:RegisterEffect(e3)
    --xyzlimit
    local e10=Effect.CreateEffect(c)
    e10:SetType(EFFECT_TYPE_SINGLE)
    e10:SetCode(EFFECT_CANNOT_BE_XYZ_MATERIAL)
    e10:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
    e10:SetValue(c62200003.mlimit)
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
function c62200003.mlimit(e,c)
    if not c then return false end
    return c:GetAttack()~=0
end
--
function c62200003.cost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.CheckLPCost(tp,1000) end
    Duel.PayLPCost(tp,1000)
end
--
function c62200003.cfilter(c,tp)
    return c:IsFaceup() and baka.check_set_FragileArticles(c) and c:GetSummonPlayer()==tp
end
function c62200003.spcon(e,tp,eg,ep,ev,re,r,rp)
    return eg:IsExists(c62200003.cfilter,1,nil,tp)
end
function c62200003.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
        and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP) end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c62200003.spop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if c:IsRelateToEffect(e) then
        Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
    end
end
--
function c62200003.dwcon(e,tp,eg,ep,ev,re,r,rp)
    return Duel.GetLP(tp)<Duel.GetLP(1-tp)
end
function c62200003.dwcost(e,tp,eg,ep,ev,re,r,rp,chk)
    local c=e:GetHandler()
    if chk==0 then return Duel.CheckLPCost(tp,1000) and c:IsDiscardable() end
    Duel.PayLPCost(tp,1000)
    Duel.SendtoGrave(c,REASON_COST+REASON_DISCARD)
end
function c62200003.dwtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsPlayerCanDraw(tp,1) end
    Duel.SetTargetPlayer(tp)
    Duel.SetTargetParam(1)
    Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c62200003.dwop(e,tp,eg,ep,ev,re,r,rp)
    local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
    Duel.Draw(p,d,REASON_EFFECT)
end