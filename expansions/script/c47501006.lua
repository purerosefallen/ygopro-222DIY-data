--圣者 姬塔
function c47501006.initial_effect(c)
    --synchro summon
    aux.AddSynchroProcedure(c,aux.FilterBoolFunction(Card.IsSynchroType,TYPE_SYNCHRO),aux.FilterBoolFunction(Card.IsCode,47500000),1,1)
    c:EnableReviveLimit()    
    --special summon rule
    local e0=Effect.CreateEffect(c)
    e0:SetType(EFFECT_TYPE_FIELD)
    e0:SetCode(EFFECT_SPSUMMON_PROC)
    e0:SetProperty(EFFECT_FLAG_UNCOPYABLE)
    e0:SetRange(LOCATION_EXTRA)
    e0:SetValue(SUMMON_TYPE_SYNCHRO)
    e0:SetCondition(c47501006.sprcon)
    e0:SetOperation(c47501006.sprop)
    c:RegisterEffect(e0) 
    --splimit
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_FIELD)
    e1:SetRange(LOCATION_PZONE)
    e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
    e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CANNOT_NEGATE)
    e1:SetTargetRange(1,0)
    e1:SetTarget(c47501006.psplimit)
    c:RegisterEffect(e1)
    --draw
    local e2=Effect.CreateEffect(c)
    e2:SetCategory(CATEGORY_DRAW)
    e2:SetType(EFFECT_TYPE_IGNITION)
    e2:SetRange(LOCATION_PZONE)
    e2:SetProperty(EFFECT_FLAG_DELAY)
    e2:SetCountLimit(1,47501006)
    e2:SetTarget(c47501006.drtg)
    e2:SetOperation(c47501006.drop)
    c:RegisterEffect(e2) 
    --
    local e5=Effect.CreateEffect(c)
    e5:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e5:SetType(EFFECT_TYPE_IGNITION)
    e5:SetRange(LOCATION_MZONE)
    e5:SetCountLimit(1)
    e5:SetTarget(c47501006.sptg)
    e5:SetOperation(c47501006.spop)
    c:RegisterEffect(e5)
end
c47501006.card_code_list={47500000}
function c47501006.pefilter(c)
    return c:IsRace(RACE_WARRIOR) or c:IsRace(RACE_SPELLCASTER)
end
function c47501006.psplimit(e,c,tp,sumtp,sumpos)
    return not c47501006.pefilter(c) and bit.band(sumtp,SUMMON_TYPE_PENDULUM)==SUMMON_TYPE_PENDULUM
end
function c47501006.fusfilter1(c)
    return c:GetOriginalCode()==47500000
end
function c47501006.cfilter(c)
    return (c:IsCode(47500000) or c:GetOriginalCode()==47500000) and c:IsCanBeSynchroMaterial() and c:IsReleasable()
end
function c47501006.spfilter1(c,tp,g)
    return g:IsExists(c47501006.spfilter2,1,c,tp,c)
end
function c47501006.spfilter2(c,tp,mc)
    return (c:GetOriginalCode()==47500000 and mc:IsCode(47500000)
        or c:IsCode(47500000) and mc:GetOriginalCode()==47500000)
        and Duel.GetLocationCountFromEx(tp,tp,Group.FromCards(c,mc))>0
end
function c47501006.sprcon(e,c)
    if c==nil then return true end
    local tp=c:GetControler()
    local g=Duel.GetMatchingGroup(c47501006.cfilter,tp,LOCATION_MZONE,0,nil)
    return g:IsExists(c47501006.spfilter1,1,nil,tp,g)
end
function c47501006.sprop(e,tp,eg,ep,ev,re,r,rp,c)
    local g=Duel.GetMatchingGroup(c47501006.cfilter,tp,LOCATION_MZONE,0,nil)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
    local g1=g:FilterSelect(tp,c47501006.spfilter1,1,1,nil,tp,g)
    local mc=g1:GetFirst()
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
    local g2=g:FilterSelect(tp,c47501006.spfilter2,1,1,mc,tp,mc)
    g1:Merge(g2)
    Duel.Release(g1,REASON_COST+REASON_MATERIAL+REASON_SYNCHRO)
end
function c47501006.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsPlayerCanDraw(tp,1) end
    Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c47501006.drop(e,tp,eg,ep,ev,re,r,rp)
    if not e:GetHandler():IsRelateToEffect(e) then return end
    Duel.Draw(tp,1,REASON_EFFECT)
    local lp1=Duel.GetLP(tp)
    local lp2=Duel.GetLP(1-tp)
    Duel.SetLP(tp,lp1+3000)
    Duel.SetLP(1-tp,lp2+3000)
end
function c47501006.spfilter(c,e,tp)
    return c:IsSetCard(0x5d0) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c47501006.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c47501006.spfilter(chkc,e,tp) end
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
        and Duel.IsExistingTarget(c47501006.spfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
    local g=Duel.SelectTarget(tp,c47501006.spfilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function c47501006.spop(e,tp,eg,ep,ev,re,r,rp)
    local tc=Duel.GetFirstTarget()
    if tc:IsRelateToEffect(e) then
        Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
        local e1=Effect.CreateEffect(c)
        e1:SetType(EFFECT_TYPE_SINGLE)
        e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
        e1:SetCode(EFFECT_EXTRA_ATTACK_MONSTER)
        e1:SetValue(1)
        e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
        c:RegisterEffect(e1)
    end
end