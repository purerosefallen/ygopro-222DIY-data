--玫瑰祖鲁
local m=47530023
local cm=_G["c"..m]
function c47530023.initial_effect(c)
    --fusion material
    c:EnableReviveLimit()
    aux.AddFusionProcCodeFun(c,c47530023.fusfilter1,c47530023.fusfilter2,1,true,true)
    aux.EnablePendulumAttribute(c,false) 
    --splimit
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_FIELD)
    e2:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
    e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CANNOT_NEGATE)
    e2:SetRange(LOCATION_PZONE)
    e2:SetTargetRange(1,0)
    e2:SetTarget(c47530023.splimit)
    c:RegisterEffect(e2)  
    --special summon rule
    local e0=Effect.CreateEffect(c)
    e0:SetType(EFFECT_TYPE_FIELD)
    e0:SetCode(EFFECT_SPSUMMON_PROC)
    e0:SetProperty(EFFECT_FLAG_UNCOPYABLE)
    e0:SetRange(LOCATION_EXTRA)
    e0:SetValue(SUMMON_TYPE_FUSION)
    e0:SetCondition(c47530023.sprcon)
    e0:SetOperation(c47530023.sprop)
    c:RegisterEffect(e0)  
    --Activate
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_QUICK_O)
    e1:SetRange(LOCATION_PZONE)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetCountLimit(1,47530023)
    e1:SetCost(c47530023.discost)
    e1:SetOperation(c47530023.disop)
    c:RegisterEffect(e1)
    --kaihi
    local e3=Effect.CreateEffect(c)
    e3:SetDescription(aux.Stringid(47530023,0))
    e3:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY)
    e3:SetType(EFFECT_TYPE_QUICK_O)
    e3:SetCode(EVENT_CHAINING)
    e3:SetCountLimit(1)
    e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
    e3:SetRange(LOCATION_MZONE)
    e3:SetCondition(c47530023.discon)
    e3:SetTarget(c47530023.distg)
    e3:SetOperation(c47530023.disop)
    c:RegisterEffect(e3)
end
function c47530023.splimit(e,c)
    return not c:IsRace(RACE_MACHINE)
end
function c47530023.lztg(e,tp,eg,ep,ev,re,r,rp,chk)
    local dis=Duel.SelectDisableField(tp,ct,0,LOCATION_MZONE,0)
    e:SetLabel(dis)
end
function c47530023.lzop(e,tp,eg,ep,ev,re,r,rp)
    local seq=e:GetLabel()
    local dg=Group.CreateGroup()
    if seq<5 then dg=Duel.GetMatchingGroup(c5087128.desfilter2,tp,0,LOCATION_MZONE,nil,seq,nil) end
    if dg:GetCount()>0 then
        Duel.SendtoGrave(dg,REASON_RULE)
    end
end
function c47530023.fusfilter1(c)
    return c:IsRace(RACE_MACHINE) and c:IsAttribute(ATTRIBUTE_DARK)
end
function c47530023.fusfilter2(c)
    return c:IsRace(RACE_MACHINE) and c:IsAttribute(ATTRIBUTE_FIRE)
end
function c47530023.cfilter(c)
    return (c47530023.fusfilter1 or c47530023.fusfilter2)
        and c:IsCanBeFusionMaterial() and c:IsReleasable()
end
function c47530023.spfilter1(c,tp,g)
    return g:IsExists(c47530023.spfilter2,1,c,tp,c)
end
function c47530023.spfilter2(c,tp,mc)
    return c:IsRace(RACE_MACHINE) and c:IsAttribute(ATTRIBUTE_DARK) and mc:IsRace(RACE_MACHINE) and mc:IsAttribute(ATTRIBUTE_FIRE)
        or c:IsRace(RACE_MACHINE) and c:IsAttribute(ATTRIBUTE_FIRE) and mc:IsRace(RACE_MACHINE) and mc:IsAttribute(ATTRIBUTE_DARK)
        and Duel.GetLocationCountFromEx(tp,tp,Group.FromCards(c,mc))>0
end
function c47530023.sprcon(e,c)
    if c==nil then return true end
    local tp=c:GetControler()
    local g=Duel.GetMatchingGroup(c47530023.cfilter,tp,LOCATION_ONFIELD,0,nil)
    return g:IsExists(c47530023.spfilter1,1,nil,tp,g)
end
function c47530023.sprop(e,tp,eg,ep,ev,re,r,rp,c)
    local g=Duel.GetMatchingGroup(c47530023.cfilter,tp,LOCATION_ONFIELD,0,nil)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
    local g1=g:FilterSelect(tp,c47530023.spfilter1,1,1,nil,tp,g)
    local mc=g1:GetFirst()
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
    local g2=g:FilterSelect(tp,c47530023.spfilter2,1,1,mc,tp,mc)
    g1:Merge(g2)
    local cg=g1:Filter(Card.IsFacedown,nil)
    if cg:GetCount()>0 then
        Duel.ConfirmCards(1-tp,cg)
    end
    Duel.Release(g1,REASON_COST+REASON_MATERIAL+REASON_FUSION)
end
function c47530023.discost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.GetMZoneCount(1-tp)>0 end
    Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(47530023,0))
    local s=Duel.SelectDisableField(tp,1,0,LOCATION_MZONE,0)/0x10000
    nseq=math.log(s,2)
    e:SetLabel(nseq)
end
function c47530023.disop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local nseq=e:GetLabel()
    if c:IsRelateToEffect(e) then 
        local e1=Effect.CreateEffect(c)
        e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
        e1:SetCategory(CATEGORY_DISABLE)
        e1:SetCode(EVENT_SPSUMMON_SUCCESS)
        e1:SetCondition(c47530023.con)
        e1:SetTarget(c47530023.tg)
        e1:SetOperation(c47530023.op)
        e1:SetLabel(nseq)
        e1:SetReset(RESET_PHASE+PHASE_END)
        Duel.RegisterEffect(e1,tp)
    end
end
function c47530023.filter(c,nseq)
    return c:GetSequence()==nseq
end
function c47530023.con(e,tp,eg,ep,ev,re,r,rp)
    return eg:IsExists(c47530023.filter,1,nil,e:GetLabel())
end
function c47530023.filter(c,nseq)
    return c:GetSequence()==nseq
end
function c47530023.tg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return true end
    Duel.SetTargetCard(eg)
    local g=eg:Filter(c47530023.filter,nil,e:GetLabel())
    Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,g,g:GetCount(),0,0)
end
function c47530023.op(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local g=eg:Filter(c47530023.filter,nil,e:GetLabel()):Filter(Card.IsRelateToEffect,nil,e)
    local tc=g:GetFirst()
    if tc then
        local e1=Effect.CreateEffect(c)
        e1:SetType(EFFECT_TYPE_SINGLE)
        e1:SetCode(EFFECT_DISABLE)
        e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
        tc:RegisterEffect(e1)
        local e2=Effect.CreateEffect(c)
        e2:SetType(EFFECT_TYPE_SINGLE)
        e2:SetCode(EFFECT_DISABLE_EFFECT)
        e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
        tc:RegisterEffect(e2)
        local e3=Effect.CreateEffect(c)
        e3:SetType(EFFECT_TYPE_SINGLE)
        e3:SetCode(EFFECT_CANNOT_TRIGGER)
        e3:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
        tc:RegisterEffect(e3)
        local e4=Effect.CreateEffect(c)
        e4:SetType(EFFECT_TYPE_SINGLE)
        e4:SetCode(EFFECT_CANNOT_ATTACK_ANNOUNCE)
        e4:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
        tc:RegisterEffect(e4)
        tc=g:GetNext()
    end
end
function c47530023.discon(e,tp,eg,ep,ev,re,r,rp)
    return not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED) and Duel.IsChainNegatable(ev)
end
function c47530023.distg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return true end
    Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
    if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then
        Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
    end
end
function c47530023.disop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if Duel.MoveToField(c,tp,tp,LOCATION_SZONE,POS_FACEUP,true) then
        if Duel.NegateActivation(ev) and re:GetHandler():IsRelateToEffect(re) then
        Duel.Destroy(eg,REASON_EFFECT)
        end
    end
end