--紫阳花与梅雨与忧郁的他
local m=22260018
local cm=_G["c"..m]
function cm.initial_effect(c)
    --token
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(22260018,0))
    e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOKEN)
    e1:SetType(EFFECT_TYPE_QUICK_O)
    e1:SetRange(LOCATION_MZONE)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetCountLimit(1)
    e1:SetCondition(c22260018.comcon)
    e1:SetTarget(c22260018.target)
    e1:SetOperation(c22260018.activate)
    c:RegisterEffect(e1)
    --SpecialSummon
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_FIELD)
    e2:SetCode(EFFECT_SPSUMMON_PROC)
    e2:SetProperty(EFFECT_FLAG_UNCOPYABLE)
    e2:SetRange(LOCATION_HAND)
    e2:SetCondition(c22260018.sprcon)
    c:RegisterEffect(e2)
    --SendtoGrave
    local e3=Effect.CreateEffect(c)
    e3:SetDescription(aux.Stringid(22260018,2))
    e3:SetCategory(CATEGORY_TOGRAVE)
    e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
    e3:SetProperty(EFFECT_FLAG_DELAY)
    e3:SetRange(LOCATION_MZONE)
    e3:SetCode(EVENT_TO_HAND)
    e3:SetCountLimit(1)
    e3:SetCondition(c22260018.sgcon)
    e3:SetTarget(c22260018.sgtg)
    e3:SetOperation(c22260018.sgop)
    c:RegisterEffect(e3)
    --xyzlimit
    local e10=Effect.CreateEffect(c)
    e10:SetType(EFFECT_TYPE_SINGLE)
    e10:SetCode(EFFECT_CANNOT_BE_XYZ_MATERIAL)
    e10:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
    e10:SetValue(c22260018.mlimit)
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
function c22260018.mlimit(e,c)
    if not c then return false end
    return c:GetAttack()~=0
end
--
function c22260018.comfilter(c)
    return c:GetBaseAttack()~=0
end 
function c22260018.comcon(e)
    return not Duel.IsExistingMatchingCard(c22260018.comfilter,e:GetHandlerPlayer(),LOCATION_ONFIELD,0,1,e:GetHandler())
end
--
function c22260018.target(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
       and Duel.IsPlayerCanSpecialSummonMonster(tp,22269996,nil,0x4011,0,0,1,RACE_PLANT,ATTRIBUTE_EARTH) end
    Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,1,0,0)
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,0)
    end
function c22260018.activate(e,tp,eg,ep,ev,re,r,rp)
    if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
    if Duel.IsPlayerCanSpecialSummonMonster(tp,22269996,nil,0x4011,0,0,1,RACE_PLANT,ATTRIBUTE_EARTH) then
    local token=Duel.CreateToken(tp,22269996)
    Duel.SpecialSummon(token,0,tp,tp,false,false,POS_FACEUP)
    end
end

function c22260018.sprfilter2(c)
    return c:IsFaceup() and c:IsRace(RACE_PLANT)
end
function c22260018.sprcon(e,c)
    if not Duel.IsExistingMatchingCard(c22260018.comfilter,e:GetHandlerPlayer(),LOCATION_ONFIELD,0,1,e:GetHandler()) then return end
    if c==nil then return true end
    local tp=c:GetControler()
    local ft=Duel.GetMZoneCount(tp)
    local ct2=Duel.GetMatchingGroupCount(c22260018.sprfilter2,tp,LOCATION_MZONE,0,nil)
    local ct3=Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)
    return ft>0 and ((ct2==ct3 and ct3>0))
end
    
function c22260018.cfilter(c,tp)
    return c:IsControler(tp) and c:IsPreviousLocation(LOCATION_DECK) and not c:IsReason(REASON_DRAW)
end
function c22260018.sgcon(e,tp,eg,ep,ev,re,r,rp)
    if not Duel.IsExistingMatchingCard(c22260018.comfilter,e:GetHandlerPlayer(),LOCATION_ONFIELD,0,1,e:GetHandler()) then return end
    return eg:IsExists(c22260018.cfilter,1,nil,1-tp)
end
function c22260018.sgtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return eg:GetCount()>0 end
    Duel.SetTargetCard(eg)
    Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,eg,eg:GetCount(),1-tp,0)
end
function c22260018.filter(c,e,tp)
    return c:IsRelateToEffect(e) and c:IsControler(tp) and c:IsPreviousLocation(LOCATION_DECK)
end
function c22260018.sgop(e,tp,eg,ep,ev,re,r,rp)
    local sg=eg:Filter(c22260018.filter,nil,e,1-tp)
    if sg:GetCount()>0 then
        Duel.SendtoGrave(sg,REASON_EFFECT)
    end
end