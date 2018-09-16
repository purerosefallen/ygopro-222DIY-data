--Nova the Aeonbreaker's Summoner
function c32904929.initial_effect(c)
    --fusion material
    c:EnableReviveLimit()
    aux.AddFusionProcFun2(c,aux.FilterBoolFunction(Card.IsFusionSetCard,0xaa12),c32904929.ffilter,true)
    --set
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(32904929,0))
    e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e1:SetCode(EVENT_SPSUMMON_SUCCESS)
    e1:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
    e1:SetCountLimit(1,32904929)
    e1:SetTarget(c32904929.settg)
    e1:SetOperation(c32904929.setop)
    c:RegisterEffect(e1)
    --spsummon
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(32904929,1))
    e2:SetCategory(CATEGORY_TOGRAVE+CATEGORY_SPECIAL_SUMMON)
    e2:SetType(EFFECT_TYPE_IGNITION)
    e2:SetRange(LOCATION_MZONE)
    e2:SetCountLimit(1,33904929)
    e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e2:SetTarget(c32904929.sptg)
    e2:SetOperation(c32904929.spop)
    c:RegisterEffect(e2)
end
function c32904929.ffilter(c)
    return c:IsRace(RACE_PSYCHO) and c:IsLevelBelow(4)
end
function c32904929.setfilter(c)
    return c:IsSetCard(0xaa12) and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsSSetable()
end
function c32904929.settg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_GRAVE) and c32904929.setfilter(chkc) end
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
        and Duel.IsExistingTarget(c32904929.setfilter,tp,LOCATION_GRAVE,0,1,nil) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
    local g=Duel.SelectTarget(tp,c32904929.setfilter,tp,LOCATION_GRAVE,0,1,1,nil)
    Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,g,1,0,0)
end
function c32904929.setop(e,tp,eg,ep,ev,re,r,rp)
    local tc=Duel.GetFirstTarget()
    if tc:IsRelateToEffect(e) and Duel.GetLocationCount(tp,LOCATION_SZONE)>0 then
        Duel.SSet(tp,tc)
        Duel.ConfirmCards(1-tp,tc)
    end
end
function c32904929.thfilter1(c)
    return c:IsFaceup() and c:IsSetCard(0xaa12) and c:IsAbleToGrave()
end
function c32904929.thfilter2(c)
    return c:IsFaceup() and c:IsSetCard(0xaa12) and c:IsAbleToGrave() and c:GetSequence()<5
end
function c32904929.spfilter(c,e,tp)
    return c:IsSetCard(0xaa12) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c32904929.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return false end
    local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
    if chk==0 then
        local b=false
        if ft>0 then
            b=Duel.IsExistingTarget(c32904929.thfilter1,tp,LOCATION_ONFIELD,0,1,nil)
        else
            b=Duel.IsExistingTarget(c32904929.thfilter2,tp,LOCATION_MZONE,0,1,nil)
        end
        return b and Duel.IsExistingTarget(c32904929.spfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp)
    end
    local g1=nil
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
    if ft>0 then
        g1=Duel.SelectTarget(tp,c32904929.thfilter1,tp,LOCATION_ONFIELD,0,1,1,nil)
    else
        g1=Duel.SelectTarget(tp,c32904929.thfilter2,tp,LOCATION_MZONE,0,1,1,nil)
    end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
    local g2=Duel.SelectTarget(tp,c32904929.spfilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
    Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,g1,1,0,0)
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g2,1,0,0)
    e:SetLabelObject(g1:GetFirst())
end
function c32904929.spop(e,tp,eg,ep,ev,re,r,rp)
    local tc1,tc2=Duel.GetFirstTarget()
    if tc1~=e:GetLabelObject() then tc1,tc2=tc2,tc1 end
    if tc1:IsRelateToEffect(e) and Duel.SendtoGrave(tc1,REASON_EFFECT)>0
        and tc1:IsLocation(LOCATION_GRAVE) and tc2:IsRelateToEffect(e) then
        Duel.SpecialSummon(tc2,0,tp,tp,false,false,POS_FACEUP)
    end
end