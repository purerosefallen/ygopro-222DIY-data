--茧墨灵能侦探事务所
function c22261504.initial_effect(c)
    --Activate
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_FREE_CHAIN)
    Duel.AddCustomActivityCounter(22261504,ACTIVITY_SPSUMMON,c22261504.counterfilter)
    c:RegisterEffect(e1)
    --spsummon
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(22261504,0))
    e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e2:SetType(EFFECT_TYPE_IGNITION)
    e2:SetRange(LOCATION_FZONE)
    e2:SetCountLimit(1)
    e2:SetCost(c22261504.cost1)
    e2:SetTarget(c22261504.sptg)
    e2:SetOperation(c22261504.spop)
    c:RegisterEffect(e2)
    --Token
    local e3=Effect.CreateEffect(c)
    e3:SetDescription(aux.Stringid(22261504,1))
    e3:SetCategory(CATEGORY_TOKEN)
    e3:SetType(EFFECT_TYPE_IGNITION)
    e3:SetRange(LOCATION_FZONE)
    e3:SetCountLimit(1)
    e3:SetCost(c22261504.tkcost)
    e3:SetTarget(c22261504.tktg)
    e3:SetOperation(c22261504.tgop)
    c:RegisterEffect(e3)
    --tohand
    local e4=Effect.CreateEffect(c)
    e4:SetDescription(aux.Stringid(22261504,2))
    e4:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
    e4:SetType(EFFECT_TYPE_IGNITION)
    e4:SetRange(LOCATION_FZONE)
    e4:SetCountLimit(1)
    e4:SetCost(c22261504.shcost)
    e4:SetTarget(c22261504.shtg)
    e4:SetOperation(c22261504.shop)
    c:RegisterEffect(e4)
end
c22261504.named_with_MayuAzaka=1
c22261504.Desc_Contain_MayuAzaka=1
function c22261504.IsMayuAzaka(c)
    local m=_G["c"..c:GetCode()]
    return m and m.named_with_MayuAzaka
end
--
function c22261504.counterfilter(c)
    return c:GetBaseAttack()~=0
end
--
function c22261504.cost1(e,tp,eg,ep,ev,re,r,rp,chk)
    local c=e:GetHandler()
    if chk==0 then return Duel.CheckLPCost(tp,3000) end
    Duel.PayLPCost(tp,3000)
end
function c22261504.spfilter(c,e,tp)
    return c:GetBaseAttack()==0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c22261504.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c22261504.spfilter,tp,LOCATION_DECK,0,1,nil,e,tp) end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c22261504.spop(e,tp,eg,ep,ev,re,r,rp)
    if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
    local g=Duel.SelectMatchingCard(tp,c22261504.spfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
    Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
end
--
function c22261504.cfilter(c,ft,tp)
    return ft>0 or (c:IsControler(tp) and c:GetSequence()<5)  and not c:IsCode(22269998)
end
function c22261504.tkcost(e,tp,eg,ep,ev,re,r,rp,chk)
    local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
    if chk==0 then return ft>-1 and Duel.CheckReleaseGroup(tp,c22261504.cfilter,1,nil,ft,tp) end
    local g=Duel.SelectReleaseGroup(tp,c22261504.cfilter,1,1,nil,ft,tp)
    Duel.Release(g,REASON_COST)
end
function c22261504.tktg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
       and Duel.IsPlayerCanSpecialSummonMonster(tp,22269998,nil,0x4011,0,0,11,RACE_FAIRY,ATTRIBUTE_DARK) end
    Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,1,0,0)
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,0)
    end
function c22261504.tgop(e,tp,eg,ep,ev,re,r,rp)
    if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
    if Duel.IsPlayerCanSpecialSummonMonster(tp,22269998,nil,0x4011,0,0,11,RACE_FAIRY,ATTRIBUTE_DARK) then
    local token=Duel.CreateToken(tp,22269998)
    Duel.SpecialSummon(token,0,tp,tp,false,false,POS_FACEUP)
    end
end
--
function c22261504.shfilter(c,ft,tp)
    return c:IsCode(22269998)
end
function c22261504.shcost(e,tp,eg,ep,ev,re,r,rp,chk)
    local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
    if chk==0 then return ft>-1 and Duel.CheckReleaseGroup(tp,c22261504.shfilter,1,nil,ft,tp) end
    local g=Duel.SelectReleaseGroup(tp,c22261504.shfilter,1,1,nil,ft,tp)
    Duel.Release(g,REASON_COST)
end
function c22261504.shfilter1(c)
    return c22261504.IsMayuAzaka(c) and c:IsAbleToHand() and c:IsType(TYPE_MONSTER)
end
function c22261504.shfilter2(c)
    return c:IsCode(22261300) and c:IsAbleToHand()
end
function c22261504.shtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c22261504.shfilter1,tp,LOCATION_DECK,0,1,nil) end
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c22261504.shop(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
    local g=Duel.SelectMatchingCard(tp,c22261504.shfilter1,tp,LOCATION_DECK,0,1,1,nil)
    if g:GetCount()>0 then
        Duel.SendtoHand(g,nil,REASON_EFFECT)
        Duel.ConfirmCards(1-tp,g)
        local mg=Duel.GetMatchingGroup(aux.NecroValleyFilter(c22261504.shfilter2),tp,LOCATION_GRAVE,0,nil)
        if mg:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(22261504,3)) then
            Duel.BreakEffect()
            Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
            local sg=mg:Select(tp,1,1,nil)
            Duel.SendtoHand(sg,nil,REASON_EFFECT)
            Duel.ConfirmCards(1-tp,sg)
        end
    end
end
