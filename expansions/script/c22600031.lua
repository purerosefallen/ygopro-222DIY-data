--音乐幻梦—再逢的愿曲
function c22600031.initial_effect(c)
    --Activate
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetCountLimit(1,22600031+EFFECT_COUNT_CODE_OATH)
    e1:SetCost(c22600031.cost)
    e1:SetTarget(c22600031.target)
    e1:SetOperation(c22600031.activate)
    c:RegisterEffect(e1)
end
function c22600031.cfilter1(c,e,tp,ft)
    local lv=c:GetLevel()
    return lv>0 and c:IsSetCard(0x260)
        and (ft>0 or (c:IsControler(tp) and c:GetSequence()<5)) and (c:IsControler(tp) or c:IsFaceup())
        and Duel.IsExistingMatchingCard(c22600031.spfilter1,tp,LOCATION_DECK,0,1,nil,e,tp,lv)
end
function c22600031.spfilter1(c,e,tp,lv)
    return c:IsSetCard(0x260) and c:GetLevel()~=lv and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c22600031.cfilter2(c,e,tp)
    local code=c:GetCode()
    return  c:IsSetCard(0x260) and c:IsType(TYPE_SYNCHRO)
        and (c:IsControler(tp) or c:IsFaceup())
        and Duel.IsExistingMatchingCard(c22600031.spfilter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,code) and Duel.GetLocationCountFromEx(tp,tp,c)>0
end
function c22600031.spfilter2(c,e,tp,code)
    return c:IsSetCard(0x260) and c:IsType(TYPE_SYNCHRO) and c:GetCode()~=code and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_SYNCHRO,tp,false,false)
end
function c22600031.cost(e,tp,eg,ep,ev,re,r,rp,chk)
    local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
    local b1=Duel.CheckReleaseGroup(tp,c22600031.cfilter1,1,nil,e,tp,ft)
    local b2=Duel.CheckReleaseGroup(tp,c22600031.cfilter2,1,nil,e,tp)
    if chk==0 then return ft>-1 and (b1 or b2) end
    if b1 and b2 then
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPTION)
        op=Duel.SelectOption(tp,aux.Stringid(22600031,0),aux.Stringid(22600031,1))
    elseif b1 then
        op=Duel.SelectOption(tp,aux.Stringid(22600031,0))
    else
        op=Duel.SelectOption(tp,aux.Stringid(22600031,1))+1
    end
    e:SetLabel(op)
    local g1=Duel.SelectReleaseGroup(tp,c22600031.cfilter1,1,1,nil,e,tp,ft)
    local g2=Duel.SelectReleaseGroup(tp,c22600031.cfilter2,1,1,nil,e,tp)
    if op==0 then
        e:SetValue(g1:GetFirst():GetLevel())
        Duel.Release(g1,REASON_COST)
    else
        e:SetValue(g2:GetFirst():GetCode())
        Duel.Destroy(g2,REASON_COST)
    end
end
function c22600031.target(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return true end
    if e:GetLabel()==0 then
        Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
    else
        Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
    end
end
function c22600031.activate(e,tp,eg,ep,ev,re,r,rp)
    if e:GetLabel()==2 or not e:GetHandler():IsRelateToEffect(e) and Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
    if e:GetLabel()==0 then
        local lv=e:GetValue()
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
        local g=Duel.SelectMatchingCard(tp,c22600031.spfilter1,tp,LOCATION_DECK,0,1,1,nil,e,tp,lv)
        if g:GetCount()>0 then
        Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
        end
    else
        local code=e:GetValue()
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
        local g=Duel.SelectMatchingCard(tp,c22600031.spfilter2,tp,LOCATION_EXTRA,0,1,1,nil,e,tp,code)
        if g:GetCount()>0 then
        Duel.SpecialSummonStep(g:GetFirst(),SUMMON_TYPE_SYNCHRO,tp,tp,false,false,POS_FACEUP)
        Duel.SpecialSummonComplete()
        end
    end
end
