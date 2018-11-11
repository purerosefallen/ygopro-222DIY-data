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
    --damage
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
    e2:SetCode(EVENT_CHAINING)
    e2:SetRange(LOCATION_MZONE)
    e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
    e2:SetOperation(c47501006.regop)
    c:RegisterEffect(e2)
    local e3=Effect.CreateEffect(c)
    e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
    e3:SetCode(EVENT_CHAIN_SOLVED)
    e3:SetRange(LOCATION_MZONE)
    e3:SetCondition(c47501006.damcon)
    e3:SetOperation(c47501006.damop)
    c:RegisterEffect(e3)
    --
    local e5=Effect.CreateEffect(c)
    e5:SetType(EFFECT_TYPE_QUICK_O)
    e5:SetRange(LOCATION_MZONE)
    e5:SetCode(EVENT_FREE_CHAIN)
    e5:SetCountLimit(1)
    e5:SetTarget(c47501006.distg)
    e5:SetOperation(c47501006.disop)
    c:RegisterEffect(e5)
end
c47501006.card_code_list={47500000}
c47501006.list={
        CATEGORY_DESTROY,
        CATEGORY_RELEASE,
        CATEGORY_REMOVE,
        CATEGORY_TOHAND,
        CATEGORY_TODECK,
        CATEGORY_TOGRAVE,
        CATEGORY_DECKDES,
        CATEGORY_HANDES,
        CATEGORY_POSITION,
        CATEGORY_CONTROL,
        CATEGORY_DISABLE,
        CATEGORY_DISABLE_SUMMON,
        CATEGORY_EQUIP,
        CATEGORY_DAMAGE,
        CATEGORY_RECOVER,
        CATEGORY_ATKCHANGE,
        CATEGORY_DEFCHANGE,
        CATEGORY_COUNTER,
        CATEGORY_LVCHANGE,
        CATEGORY_NEGATE,
}
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
function c47501006.regop(e,tp,eg,ep,ev,re,r,rp)
    e:GetHandler():RegisterFlagEffect(47501006,RESET_EVENT+RESETS_STANDARD-RESET_TURN_SET+RESET_CHAIN,0,1)
end
function c47501006.damcon(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    return ep~=tp and c:GetFlagEffect(47501006)~=0
end
function c47501006.damop(e,tp,eg,ep,ev,re,r,rp)
    local lp=Duel.GetLP(1-tp)
    Duel.Hint(HINT_CARD,0,47501006)
    Duel.SetLP(1-tp,lp-500)
end
function c47501006.distg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(Card.IsFaceup,tp,0,LOCATION_MZONE,1,nil) end
end
function c47501006.disop(e,tp,eg,ep,ev,re,r,rp)
    local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,0,LOCATION_MZONE,nil)
    local tc=g:GetFirst()
    local c=e:GetHandler()
    while tc do
        local e1=Effect.CreateEffect(c)
        e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
        e1:SetCode(EVENT_CHAIN_SOLVING)
        e1:SetRange(LOCATION_MZONE)
        e1:SetCondition(c47501006.discon2)
        e1:SetOperation(c47501006.disop2)
        e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
        tc:RegisterEffect(e1)
       tc=g:GetNext()
    end
end
function c47501006.nfilter(c,tp)
    return c:IsLocation(LOCATION_MZONE) and c:IsControler(tp)
end
function c47501006.discon2(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED) or not Duel.IsChainNegatable(ev) or rp==1-tp then return false end
    if c47501006.nfilter(re:GetHandler()) then return true end
    local g=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)
    if g and g:IsExists(c47501006.nfilter,1,nil) then return true end
    local res,ceg,cep,cev,re,r,rp=Duel.CheckEvent(re:GetCode())
    if res and ceg and ceg:IsExists(c47501006.nfilter,1,nil) then return true end
    for i,ctg in pairs(c47501006.list) do
        local ex,tg,ct,p,v=Duel.GetOperationInfo(ev,ctg)
        if tg then
            if tg:IsExists(c47501006.nfilter,1,c) then return true end
        elseif v and v>0 and Duel.IsExistingMatchingCard(c47501006.nfilter,tp,v,0,1,nil) then
            return true
        end
    end
    return false
end
function c47501006.disop2(e,tp,eg,ep,ev,re,r,rp)
    Duel.NegateEffect(ev)
end