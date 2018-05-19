--山茶花与蝶与眩晕的他
local m=22260019
local cm=_G["c"..m]
function cm.initial_effect(c)
    --token
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(22260019,0))
    e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOKEN)
    e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
    e1:SetCode(EVENT_TO_GRAVE)
    e1:SetCountLimit(1,222600190)
    e1:SetCondition(c22260019.con)
    e1:SetTarget(c22260019.tg)
    e1:SetOperation(c22260019.op)
    c:RegisterEffect(e1)
    --SpecialSummon
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(22260019,1))
    e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e2:SetProperty(EFFECT_FLAG_DELAY)
    e2:SetCode(EVENT_TO_HAND)
    e2:SetCountLimit(1,222600191)
    e2:SetCondition(c22260019.spcon)
    e2:SetTarget(c22260019.sptg)
    e2:SetOperation(c22260019.spop)
    c:RegisterEffect(e2)

end

--
function c22260019.con(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    return c:IsPreviousLocation(LOCATION_ONFIELD) and c:IsReason(REASON_DESTROY) and c:IsReason(REASON_BATTLE+REASON_EFFECT)
end
function c22260019.tg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
       and Duel.IsPlayerCanSpecialSummonMonster(tp,22269995,nil,0x4011,0,0,1,RACE_PLANT,ATTRIBUTE_EARTH) end
    Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,1,0,0)
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,0)
    end
function c22260019.op(e,tp,eg,ep,ev,re,r,rp)
    if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
    if Duel.IsPlayerCanSpecialSummonMonster(tp,22269995,nil,0x4011,0,0,1,RACE_PLANT,ATTRIBUTE_EARTH) then
    local token=Duel.CreateToken(tp,22269995)
    Duel.SpecialSummon(token,0,tp,tp,false,false,POS_FACEUP)
    end
end
--
function c22260019.spcon(e,tp,eg,ep,ev,re,r,rp)
    return not e:GetHandler():IsReason(REASON_DRAW)
end
function c22260019.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
    local c=e:GetHandler()
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
        and c:IsCanBeSpecialSummoned(e,0,tp,false,false) end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function c22260019.spop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if not c:IsRelateToEffect(e) then return end
    Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
end
--
