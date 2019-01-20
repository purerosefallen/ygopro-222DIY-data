--紫阳花与梅雨与忧郁的他
local m=62210003
local cm=_G["c"..m]
xpcall(function() require("expansions/script/c62200000")end,function() require("script/c62200000") end)
cm.named_with_AnoKare=true

function cm.initial_effect(c)
    --spsummon
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(m,0))
    e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e1:SetType(EFFECT_TYPE_IGNITION)
    e1:SetRange(LOCATION_HAND)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetCost(cm.spcost)
    e1:SetCondition(cm.spcon)
    e1:SetTarget(cm.sptg)
    e1:SetOperation(cm.spop)
    c:RegisterEffect(e1)
    --token
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(m,1))
    e2:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOKEN)
    e2:SetType(EFFECT_TYPE_IGNITION)
    e2:SetRange(LOCATION_MZONE)
    e2:SetCode(EVENT_FREE_CHAIN)
    e2:SetCost(cm.tokencost)
    e2:SetTarget(cm.tokentg)
    e2:SetOperation(cm.tokenop)
    c:RegisterEffect(e2)    
    --xyzlimit
    local e100=Effect.CreateEffect(c)
    e100:SetType(EFFECT_TYPE_SINGLE)
    e100:SetCode(EFFECT_CANNOT_BE_XYZ_MATERIAL)
    e100:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
    e100:SetValue(cm.mlimit)
    c:RegisterEffect(e100)
    local e110=e100:Clone()
    e110:SetCode(EFFECT_CANNOT_BE_SYNCHRO_MATERIAL)
    c:RegisterEffect(e110)
    local e120=e100:Clone()
    e120:SetCode(EFFECT_CANNOT_BE_FUSION_MATERIAL)
    c:RegisterEffect(e120)
    local e130=e100:Clone()
    e130:SetCode(EFFECT_CANNOT_BE_LINK_MATERIAL)
    c:RegisterEffect(e130)      
end
--
function cm.mlimit(e,c)
    if not c then return false end
    return c:GetAttack()~=0
end
--
function cm.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
    local fa=Duel.GetFlagEffect(tp,622100000)
    local fb=Duel.GetFlagEffect(tp,622100001)
    local c=e:GetHandler()
    local fc=fa-fb
    if chk==0 then return fc<3 end
    Duel.RegisterFlagEffect(tp,622100000,RESET_PHASE+PHASE_END,0,1)
end
function cm.cfilter(c)
    return c:IsFaceup() and c:IsRace(RACE_PLANT)
end
function cm.spcon(e,tp,eg,ep,ev,re,r,rp)
    return  Duel.IsExistingMatchingCard(cm.cfilter,tp,LOCATION_MZONE,0,1,nil)
end
function cm.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
        and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if c:IsRelateToEffect(e) then
        Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
    end
end
--
function cm.tokencost(e,tp,eg,ep,ev,re,r,rp,chk)
    local fa=Duel.GetFlagEffect(tp,622100000)
    local fb=Duel.GetFlagEffect(tp,622100001)
    local c=e:GetHandler()
    local fc=fa-fb
    if chk==0 then return fc<3 and Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,e:GetHandler()) end
    Duel.RegisterFlagEffect(tp,622100000,RESET_PHASE+PHASE_END,0,1)
    Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_COST+REASON_DISCARD)
end
function cm.tokentg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
        and Duel.IsPlayerCanSpecialSummonMonster(tp,62219997,nil,0x4011,0,0,4,RACE_PLANT,ATTRIBUTE_EARTH) end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,0)
    Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,1,0,0)
end
function cm.tokenop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
    if Duel.IsPlayerCanSpecialSummonMonster(tp,62219997,nil,0x4011,0,0,1,RACE_PLANT,ATTRIBUTE_EARTH) then
    local token=Duel.CreateToken(tp,62219997)
    Duel.SpecialSummon(token,0,tp,tp,false,false,POS_FACEUP)
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetCode(EFFECT_CANNOT_BE_FUSION_MATERIAL)
    e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_IGNORE_IMMUNE)
    e1:SetValue(cm.mlimit)
    e1:SetReset(RESET_EVENT+RESETS_STANDARD)
    token:RegisterEffect(e1)
    local e2=e1:Clone()
    e2:SetCode(EFFECT_CANNOT_BE_SYNCHRO_MATERIAL)
    token:RegisterEffect(e2)
    local e3=e1:Clone()
    e3:SetCode(EFFECT_CANNOT_BE_XYZ_MATERIAL)
    token:RegisterEffect(e3)
    local e4=e1:Clone()
    e4:SetCode(EFFECT_CANNOT_BE_LINK_MATERIAL)
    token:RegisterEffect(e4)
    end
end