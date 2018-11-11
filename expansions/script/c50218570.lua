--征伏龙王-狰狞
function c50218570.initial_effect(c)
    --link summon
    aux.AddLinkProcedure(c,c50218570.check,2,2,c50218570.lcheck)
    c:EnableReviveLimit()
    --xyz
    local e1=Effect.CreateEffect(c)
    e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e1:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
    e1:SetCode(EVENT_SPSUMMON_SUCCESS)
    e1:SetCountLimit(1,50218570)
    e1:SetCondition(c50218570.spcon)
    e1:SetTarget(c50218570.sptg)
    e1:SetOperation(c50218570.spop)
    c:RegisterEffect(e1)
    --material
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e2:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
    e2:SetCode(EVENT_TO_GRAVE)
    e2:SetCondition(c50218570.matcon)
    e2:SetTarget(c50218570.mattg)
    e2:SetOperation(c50218570.matop)
    c:RegisterEffect(e2)
    --draw
    local e3=Effect.CreateEffect(c)
    e3:SetCategory(CATEGORY_DRAW)
    e3:SetType(EFFECT_TYPE_XMATERIAL+EFFECT_TYPE_TRIGGER_F)
    e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
    e3:SetCode(EVENT_BATTLE_DESTROYING)
    e3:SetCondition(aux.bdocon)
    e3:SetTarget(c50218570.drtg)
    e3:SetOperation(c50218570.drop)
    c:RegisterEffect(e3)
end
function c50218570.check(c)
    return c:IsLevelAbove(1)
end
function c50218570.lcheck(g)
    return g:GetClassCount(Card.GetLevel)==1
end
function c50218570.spcon(e,tp,eg,ep,ev,re,r,rp)
    return e:GetHandler():IsSummonType(SUMMON_TYPE_LINK)
end
function c50218570.filter(c,e,tp)
    return c:IsCanBeEffectTarget(e) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c50218570.xyzfilter(c,mg)
    return c:IsXyzSummonable(mg,2,2) and c:IsSetCard(0xcb5)
end
function c50218570.mfilter1(c,mg,exg)
    return mg:IsExists(c50218570.mfilter2,1,c,c,exg)
end
function c50218570.mfilter2(c,mc,exg)
    return exg:IsExists(Card.IsXyzSummonable,1,nil,Group.FromCards(c,mc))
end
function c50218570.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return false end
    local mg=Duel.GetMatchingGroup(c50218570.filter,tp,LOCATION_GRAVE,0,nil,e,tp)
    local exg=Duel.GetMatchingGroup(c50218570.xyzfilter,tp,LOCATION_EXTRA,0,nil,mg)
    if chk==0 then return Duel.IsPlayerCanSpecialSummonCount(tp,2)
        and not Duel.IsPlayerAffectedByEffect(tp,59822133)
        and Duel.GetLocationCount(tp,LOCATION_MZONE)>1
        and exg:GetCount()>0 end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
    local sg1=mg:FilterSelect(tp,c50218570.mfilter1,1,1,nil,mg,exg)
    local tc1=sg1:GetFirst()
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
    local sg2=mg:FilterSelect(tp,c50218570.mfilter2,1,1,tc1,tc1,exg)
    sg1:Merge(sg2)
    Duel.SetTargetCard(sg1)
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,sg1,2,0,0)
end
function c50218570.filter2(c,e,tp)
    return c:IsRelateToEffect(e) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c50218570.spop(e,tp,eg,ep,ev,re,r,rp)
    if Duel.IsPlayerAffectedByEffect(tp,59822133) then return end
    if Duel.GetLocationCount(tp,LOCATION_MZONE)<2 then return end
    local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(c50218570.filter2,nil,e,tp)
    if g:GetCount()<2 then return end
    local tc=g:GetFirst()
    while tc do
        Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEUP)
        local e1=Effect.CreateEffect(e:GetHandler())
        e1:SetType(EFFECT_TYPE_SINGLE)
        e1:SetCode(EFFECT_DISABLE)
        e1:SetReset(RESET_EVENT+RESETS_STANDARD)
        tc:RegisterEffect(e1)
        local e2=e1:Clone()
        e2:SetCode(EFFECT_DISABLE_EFFECT)
        tc:RegisterEffect(e2)
        tc=g:GetNext()
    end
    Duel.SpecialSummonComplete()
    Duel.BreakEffect()
    local xyzg=Duel.GetMatchingGroup(c50218570.xyzfilter,tp,LOCATION_EXTRA,0,nil,g)
    if xyzg:GetCount()>0 then
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
        local xyz=xyzg:Select(tp,1,1,nil):GetFirst()
        Duel.XyzSummon(tp,xyz,g)
    end
end
function c50218570.matcon(e,tp,eg,ep,ev,re,r,rp)
    return e:GetHandler():IsReason(REASON_DESTROY)
end
function c50218570.matfilter(c)
    return c:IsFaceup() and c:IsType(TYPE_XYZ)
end
function c50218570.mattg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c50218570.matfilter(chkc) end
    if chk==0 then return Duel.IsExistingTarget(c50218570.matfilter,tp,LOCATION_MZONE,0,1,nil) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
    Duel.SelectTarget(tp,c50218570.matfilter,tp,LOCATION_MZONE,0,1,1,nil)
    Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,e:GetHandler(),1,0,0)
end
function c50218570.matop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local tc=Duel.GetFirstTarget()
    if c:IsRelateToEffect(e) and tc:IsRelateToEffect(e) and not tc:IsImmuneToEffect(e) then
        Duel.Overlay(tc,Group.FromCards(c))
    end
end
function c50218570.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return true end
    Duel.SetTargetPlayer(tp)
    Duel.SetTargetParam(1)
    Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c50218570.drop(e,tp,eg,ep,ev,re,r,rp)
    local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
    Duel.Draw(p,d,REASON_EFFECT)
end