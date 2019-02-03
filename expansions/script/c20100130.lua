--ReLive-Eru
local m=20100130
local cm=_G["c"..m]
xpcall(function() require("expansions/script/c20100002") end,function() require("script/c20100002") end)
function cm.initial_effect(c)
    Cirn9.ReLiveMonster(c)
    --link summon
    aux.AddLinkProcedure(c,nil,2,99,cm.lcheck)
    c:EnableReviveLimit()
    --indes
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_FIELD)
    e1:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
    e1:SetRange(LOCATION_MZONE)
    e1:SetTargetRange(LOCATION_FZONE,0)
    e1:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0xc99))
    e1:SetValue(1)
    c:RegisterEffect(e1)
    local e2=e1:Clone()
    e2:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
    e2:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
    e2:SetValue(aux.tgoval)
    c:RegisterEffect(e2)
    --Climax Act
    local e3=Effect.CreateEffect(c)
    e3:SetDescription(aux.Stringid(m,0))
    e3:SetType(EFFECT_TYPE_IGNITION)
    e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e3:SetRange(LOCATION_MZONE)
    e3:SetCountLimit(1,m)
    e3:SetCondition(Cirn9.clcon)
    e3:SetTarget(cm.cltg)
    e3:SetOperation(cm.clop)
    c:RegisterEffect(e3)
    --Finish Act
    local e4=Effect.CreateEffect(c)
    e4:SetDescription(aux.Stringid(m,1))
    e4:SetType(EFFECT_TYPE_IGNITION)
    e4:SetRange(LOCATION_MZONE)
    e4:SetCountLimit(1,m)
    e4:SetCondition(cm.facon)
    e4:SetTarget(cm.fatg)
    e4:SetOperation(cm.faop)
    c:RegisterEffect(e4)
    
end
function cm.lcheck(g,lc)
    return g:IsExists(Card.IsLinkSetCard,1,nil,0xc99)
end

function cm.efffilter(c,e,tp,eg,ep,ev,re,r,rp)
    if not (c:IsSetCard(0xc99) and c:IsType(TYPE_MONSTER) and c:IsFaceup()) then return false end
    local m=_G["c"..c:GetCode()]
    if not m then return false end
    local te=m.ClimaxAct
    if not te then return false end
    local tg=te:GetTarget()
    return not tg or tg and tg(e,tp,eg,ep,ev,re,r,rp,0)
end
function cm.cltg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and cm.efffilter(chkc,e,tp,eg,ep,ev,re,r,rp) end
    if chk==0 then return Duel.IsExistingTarget(cm.efffilter,tp,LOCATION_MZONE,0,1,nil,e,tp,eg,ep,ev,re,r,rp) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
    local g=Duel.SelectTarget(tp,cm.efffilter,tp,LOCATION_MZONE,0,1,1,nil,e,tp,eg,ep,ev,re,r,rp)
    local tc=g:GetFirst()
    Duel.ClearTargetCard()
    tc:CreateEffectRelation(e)
    e:SetLabelObject(tc)
    local m=_G["c"..tc:GetCode()]
    local te=m.ClimaxAct
    local tg=te:GetTarget()
    if tg then tg(e,tp,eg,ep,ev,re,r,rp,1) end
end
function cm.clop(e,tp,eg,ep,ev,re,r,rp,chk)
    local tc=e:GetLabelObject()
    if tc:IsRelateToEffect(e) then
        local m=_G["c"..tc:GetCode()]
        local te=m.ClimaxAct
        local op=te:GetOperation()
        if op then op(e,tp,eg,ep,ev,re,r,rp) end
    end
end
function cm.fa1(c,tp)
    return c:IsSetCard(0xc99) and c:IsFaceup()
end
function cm.desfilter(c)
    return c:IsType(TYPE_SPELL+TYPE_TRAP)
end
function cm.fa2(c,tp)
    local cg=c:GetColumnGroup():FilterCount(Card.IsControler,nil,1-tp)
    return cg>0 and c:IsFaceup() and c:IsSetCard(0xc99)
end
function cm.facon(e,tp,eg,ep,ev,re,r,rp)
    local fc=Duel.GetFieldCard(tp,LOCATION_SZONE,5)
    if not fc or fc:IsFacedown() then return false end
    if not (fc:IsSetCard(0xc99) and fc:IsAbleToGraveAsCost()) then return false end
    if not Duel.IsExistingMatchingCard(cm.fa1,tp,LOCATION_MZONE,0,2,nil) then return false end
    if fc:IsCode(20100108) and not Duel.IsExistingMatchingCard(Card.IsFaceup,tp,0,LOCATION_MZONE,1,nil) then return false end
    if fc:IsCode(20100114) then
        local mtg=Duel.GetMatchingGroupCount(cm.desfilter,tp,0,LOCATION_ONFIELD,nil)
        local clg=Duel.GetMatchingGroup(cm.fa2,tp,LOCATION_MZONE,0,nil,tp)
        if mtg<1 and clg:GetCount()<1 then return false end
    end
    return true
end
function cm.ffilter(c,e,tp,eg,ep,ev,re,r,rp)
    if not (c:IsSetCard(0xc99) and c:IsType(TYPE_FIELD) and c:IsFaceup()) then return false end
    local m=_G["c"..c:GetCode()]
    if not m then return false end
    local te=m.FinishAct
    if not te then return false end
    local tg=te:GetTarget()
    return not tg or tg and tg(e,tp,eg,ep,ev,re,r,rp,0)
end
function cm.fatg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and cm.ffilter(chkc,e,tp,eg,ep,ev,re,r,rp) end
    if chk==0 then return Duel.IsExistingTarget(cm.ffilter,tp,LOCATION_FZONE,0,1,nil,e,tp,eg,ep,ev,re,r,rp) end
    local tc=Duel.GetFieldCard(tp,LOCATION_SZONE,5)
    Duel.SendtoGrave(tc,REASON_EFFECT)
    Duel.ClearTargetCard()
    tc:CreateEffectRelation(e)
    e:SetLabelObject(tc)
    local m=_G["c"..tc:GetCode()]
    local te=m.FinishAct
    local tg=te:GetTarget()
    if tg then tg(e,tp,eg,ep,ev,re,r,rp,1) end
end
function cm.faop(e,tp,eg,ep,ev,re,r,rp,chk)
    local tc=e:GetLabelObject()
    if tc:IsRelateToEffect(e) then
        local m=_G["c"..tc:GetCode()]
        local te=m.FinishAct
        local op=te:GetOperation()
        if op then op(e,tp,eg,ep,ev,re,r,rp) end
    end
end