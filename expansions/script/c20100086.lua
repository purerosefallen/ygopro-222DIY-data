--ReLive-Yuyuko
local m=20100086
local cm=_G["c"..m]
xpcall(function() require("expansions/script/c20100002") end,function() require("script/c20100002") end)
function cm.initial_effect(c)
    Cirn9.ReLiveMonster(c)
    --Destroy
    local e1=Effect.CreateEffect(c)
    e1:SetCategory(CATEGORY_DESTROY+CATEGORY_COUNTER)
    e1:SetDescription(aux.Stringid(m,0))
    e1:SetType(EFFECT_TYPE_IGNITION)
    e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e1:SetCountLimit(1)
    e1:SetRange(LOCATION_MZONE)
    e1:SetCost(Cirn9.ap2)
    e1:SetTarget(cm.destg)
    e1:SetOperation(cm.desop)
    c:RegisterEffect(e1)     
    --spsummon
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(m,1))
    e2:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_COUNTER)
    e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_QUICK_O)
    e2:SetCode(EVENT_CHAINING)
    e2:SetRange(LOCATION_HAND)
    e2:SetCost(Cirn9.ap2)
    e2:SetCondition(cm.spcon)
    e2:SetTarget(cm.sptg)
    e2:SetOperation(cm.spop)
    c:RegisterEffect(e2)  
    --can not activate effect needs target 
    local e3=Effect.CreateEffect(c)
    e3:SetDescription(aux.Stringid(m,2))
    e3:SetType(EFFECT_TYPE_IGNITION)
    e3:SetCountLimit(1)
    e3:SetRange(LOCATION_MZONE)
    e3:SetCondition(Cirn9.clcon)
    e3:SetCost(Cirn9.clcost)
    e3:SetOperation(cm.cnteop)
    c:RegisterEffect(e3) 
    cm.ClimaxAct=e3
end
function cm.filter(c)
    return c:IsType(TYPE_SPELL) and c:IsFaceup()
end
function cm.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return chkc:IsLocation(LOCATION_SZONE) and chkc:IsControler(1-tp) and cm.filter(chkc) end
    if chk==0 then return Duel.IsExistingTarget(cm.filter,tp,0,LOCATION_SZONE,1,nil) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
    local g=Duel.SelectTarget(tp,cm.filter,tp,0,LOCATION_SZONE,1,1,nil)
    Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
    Duel.SetOperationInfo(0,CATEGORY_COUNTER,nil,1,0,0xc99)
end
function cm.desop(e,tp,eg,ep,ev,re,r,rp)
    local tc=Duel.GetFirstTarget()
    if tc:IsRelateToEffect(e) then
        if Duel.Destroy(tc,REASON_EFFECT)~=0 and e:GetHandler():IsRelateToEffect(e) then
            Duel.BreakEffect()
            if e:GetHandler():IsSummonType(SUMMON_TYPE_ADVANCE) then
                e:GetHandler():AddCounter(0xc99,2)
            else
                e:GetHandler():AddCounter(0xc99,1)
            end
        end
    end
end
function cm.spcon(e,tp,eg,ep,ev,re,r,rp)
    if rp==tp or not re:IsHasProperty(EFFECT_FLAG_CARD_TARGET) then return false end
    local g=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)
    if not g or g:GetCount()~=1 then return false end
    local tg=g:GetFirst()
    return tg:IsFaceup() and tg:IsSetCard(0xc99) and tg:IsLocation(LOCATION_MZONE)
end
function cm.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
    local c=e:GetHandler()
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
        and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and not re:GetHandler():IsStatus(STATUS_DISABLED) end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
    Duel.SetOperationInfo(0,CATEGORY_COUNTER,nil,1,0,0xc99)
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if c:IsRelateToEffect(e) and Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)~=0 then
        c:AddCounter(0xc99,1)
        local tf=re:GetTarget()
        local res,ceg,cep,cev,cre,cr,crp=Duel.CheckEvent(re:GetCode(),true)
        if tf(re,rp,ceg,cep,cev,cre,cr,crp,0,c) then
            local g=Group.CreateGroup()
            g:AddCard(c)
            Duel.ChangeTargetCard(ev,g)
            if Duel.IsChainDisablable(ev) and Duel.IsEnvironment(20100114) then
                Duel.NegateEffect(ev)
            end
        end
    end
end
function cm.cnteop(e,tp,eg,ep,ev,re,r,rp)
    local revue=Cirn9.Climax(e,tp,eg,ep,ev,re,r,rp)
    if revue==0 then return
    elseif revue==1 then Cirn9.RevueBgm(tp) end 
    --cannot attack announce 
    local c=e:GetHandler()
    local e4=Effect.CreateEffect(c)
    e4:SetType(EFFECT_TYPE_FIELD)
    e4:SetCode(EFFECT_CANNOT_ACTIVATE)
    e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
    e4:SetTargetRange(0,1)
    e4:SetCondition(cm.accon)
    e4:SetLabel(Duel.GetTurnCount())
    e4:SetValue(cm.aclimit)
    e4:SetReset(RESET_PHASE+PHASE_END,2)
    Duel.RegisterEffect(e4,tp)
end
function cm.accon(e)
    return e:GetLabel()~=Duel.GetTurnCount()
end
function cm.aclimit(e,re,tp)
    return re:IsHasProperty(EFFECT_FLAG_CARD_TARGET)
end