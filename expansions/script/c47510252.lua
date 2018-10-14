--维拉=修瓦利耶
local m=47510252
local cm=_G["c"..m]
cm.dfc_front_side=m
cm.dfc_back_side=m+2
function c47510252.initial_effect(c)
    aux.EnablePendulumAttribute(c) 
    --fusion material
    c:EnableReviveLimit()
    aux.AddFusionProcFunRep(c,c47510252.ffilter,1,true)  
    --special summon rule
    local e0=Effect.CreateEffect(c)
    e0:SetType(EFFECT_TYPE_FIELD)
    e0:SetCode(EFFECT_SPSUMMON_PROC)
    e0:SetProperty(EFFECT_FLAG_UNCOPYABLE)
    e0:SetRange(LOCATION_EXTRA)
    e0:SetValue(SUMMON_TYPE_FUSION)
    e0:SetCondition(c47510252.sprcon)
    e0:SetOperation(c47510252.sprop)
    c:RegisterEffect(e0)  
    --synchro limit
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetCode(EFFECT_CANNOT_BE_SYNCHRO_MATERIAL)
    e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
    e1:SetValue(c47510252.synlimit)
    c:RegisterEffect(e1)
    --draw
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(47510252,1))
    e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
    e2:SetCode(EVENT_BE_MATERIAL)
    e2:SetCondition(c47510252.pencon)
    e2:SetTarget(c47510252.pentg)
    e2:SetOperation(c47510252.penop)
    c:RegisterEffect(e2) 
    --spssummon
    local e3=Effect.CreateEffect(c)
    e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e3:SetCode(EVENT_SPSUMMON_SUCCESS)
    e3:SetCountLimit(1,47510252)
    e3:SetCondition(c47510252.thcon)
    e3:SetTarget(c47510252.thtg)
    e3:SetOperation(c47510252.thop)
    c:RegisterEffect(e3) 
    --splimit
    local e5=Effect.CreateEffect(c)
    e5:SetType(EFFECT_TYPE_IGNITION)
    e5:SetRange(LOCATION_PZONE)
    e5:SetCountLimit(1,47510252)
    e5:SetTarget(c47510252.tftg)
    e5:SetOperation(c47510252.tfop)
    c:RegisterEffect(e5)
    --Change
    local e6=Effect.CreateEffect(c)
    e6:SetDescription(aux.Stringid(47510252,0))
    e6:SetType(EFFECT_TYPE_IGNITION)
    e6:SetRange(LOCATION_MZONE)
    e6:SetCountLimit(1,47510253)
    e6:SetCost(c47510252.chcost)
    e6:SetTarget(c47510252.changetg)
    e6:SetOperation(c47510252.changeop)
    c:RegisterEffect(e6)  
    local e7=e6:Clone()
    e7:SetRange(LOCATION_PZONE)
    c:RegisterEffect(e7)
end
function c47510252.synlimit(e,c)
    if not c then return false end
    return not c:IsType(TYPE_PENDULUM)
end
function c47510252.spfilter(c)
    return c:IsType(TYPE_PENDULUM) and c:IsLevelAbove(5) and c:IsCanBeFusionMaterial()
end
function c47510252.fselect(c,tp,mg,sg)
    sg:AddCard(c)
    local res=false
    if sg:GetCount()<1 then
        res=mg:IsExists(c47510252.fselect,1,sg,tp,mg,sg)
    else
        res=Duel.GetLocationCountFromEx(tp,tp,sg)>0
    end
    sg:RemoveCard(c)
    return res
end
function c47510252.sprcon(e,c)
    if c==nil then return true end
    local tp=c:GetControler()
    local mg=Duel.GetMatchingGroup(c47510252.spfilter,tp,LOCATION_MZONE,0,nil)
    local sg=Group.CreateGroup()
    return mg:IsExists(c47510252.fselect,1,nil,tp,mg,sg)
end
function c47510252.sprop(e,tp,eg,ep,ev,re,r,rp,c)
    local mg=Duel.GetMatchingGroup(c47510252.spfilter,tp,LOCATION_MZONE,0,nil)
    local sg=Group.CreateGroup()
    while sg:GetCount()<1 do
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
        local g=mg:FilterSelect(tp,c47510252.fselect,1,1,sg,tp,mg,sg)
        sg:Merge(g)
    end
    Duel.Release(sg,REASON_COST+REASON_MATERIAL+REASON_FUSION)
end
function c47510252.thfilter(c,e,tp,dam)
    return c:IsType(TYPE_PENDULUM) and c:IsAbleToHand()
end
function c47510252.penfilter(c)
    return c:IsType(TYPE_PENDULUM) and not c:IsForbidden() and c:IsFaceup()
end
function c47510252.thcon(e,tp,eg,ep,ev,re,r,rp)
    return e:GetHandler():IsSummonType(SUMMON_TYPE_FUSION)
end
function c47510252.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c47510252.thfilter,tp,LOCATION_PZONE,0,1,nil,e,tp,ev) end
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_PZONE)
end
function c47510252.thop(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
    local g=Duel.SelectMatchingCard(tp,c47510252.thfilter,tp,LOCATION_PZONE,0,1,1,nil,e,tp,ev)
    if g:GetCount()>0 and Duel.SendtoHand(g,nil,REASON_EFFECT) then
        Duel.ConfirmCards(1-tp,g)
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
        local g=Duel.SelectMatchingCard(tp,c47510252.penfilter,tp,LOCATION_EXTRA,0,1,1,nil)
        local tc=g:GetFirst()
        if tc then
            Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
        end
    end
end
function c47510252.pencon(e,tp,eg,ep,ev,re,r,rp)
    return e:GetHandler():IsLocation(LOCATION_EXTRA) and r==REASON_SYNCHRO
end
function c47510252.pentg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.GetFieldGroupCount(tp,LOCATION_PZONE,0)>0 end
    local g=Duel.GetFieldGroup(tp,LOCATION_PZONE,0)
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,g:GetCount(),0,LOCATION_PZONE)
end
function c47510252.penop(e,tp,eg,ep,ev,re,r,rp)
    local g=Duel.GetFieldGroup(tp,LOCATION_PZONE,0)
    if g:GetCount()>0 and Duel.SendtoHand(g,tp,REASON_EFFECT) then
        local c=e:GetHandler()
        if c:IsRelateToEffect(e) then
            Duel.MoveToField(c,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
        end
    end
end
function c47510252.chfilter(c)
    return c:IsType(TYPE_PENDULUM) and c:IsLevelAbove(7)
end
function c47510252.chcost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.CheckReleaseGroup(tp,c47510252.chfilter,2,e:GetHandler()) end
    local g=Duel.SelectReleaseGroup(tp,c47510252.chfilter,2,2,e:GetHandler())
    Duel.Release(g,REASON_COST)
end
function c47510252.changetg(e,tp,eg,ep,ev,re,r,rp,chk)
    local c=e:GetHandler()
    if chk==0 then return c.dfc_back_side and c.dfc_front_side==c:GetOriginalCode() end
    Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
end
function c47510252.changeop(e,tp,eg,ep,ev,re,r,rp,chk)
    local c=e:GetHandler()
    if not c:IsRelateToEffect(e) or c:IsFacedown() or c:IsImmuneToEffect(e) then return end
    local tcode=c.dfc_back_side
    c:SetEntityCode(tcode,true)
    c:ReplaceEffect(tcode,0,0)
end
function c47510252.tffilter(c)
    return c:IsType(TYPE_CONTINUOUS) and c:IsType(TYPE_SPELL)
end
function c47510252.tftg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c47510252.tffilter,tp,LOCATION_GRAVE,0,1,nil) end
end
function c47510252.tfop(e,tp,eg,ep,ev,re,r,rp)
    if Duel.GetLocationCount(tp,LOCATION_SZONE)<1 then return end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
    local g=Duel.SelectMatchingCard(tp,c47510252.tffilter,tp,LOCATION_GRAVE,0,1,1,nil)
    local tc=g:GetFirst()
    if tc then
        Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
        local e2=Effect.CreateEffect(tc)
        e2:SetType(EFFECT_TYPE_SINGLE)
        e2:SetRange(LOCATION_SZONE)
        e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE)
        e2:SetCode(EFFECT_LINK_SPELL_KOISHI)
        e2:SetValue(LINK_MARKER_TOP+LINK_MARKER_TOP_LEFT+LINK_MARKER_TOP_RIGHT)
        e2:SetReset(RESET_EVENT+RESETS_STANDARD)
        tc:RegisterEffect(e2)
    end
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_FIELD)
    e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
    e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
    e1:SetTargetRange(1,0)
    e1:SetTarget(c47510252.splimit)
    e1:SetReset(RESET_PHASE+PHASE_END)
    Duel.RegisterEffect(e1,tp)
end
function c47510252.splimit(e,c)
    return c:IsType(TYPE_LINK)
end