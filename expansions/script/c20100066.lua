--ReLive-Junna
require("expansions/script/c20100002")
local m=20100066
local cm=_G["c"..m]
function cm.initial_effect(c)
    Cirn9.ReLiveMonster(c)
    --damage
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(m,0))
    e1:SetCategory(CATEGORY_DAMAGE+CATEGORY_COUNTER)
    e1:SetType(EFFECT_TYPE_IGNITION)
    e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
    e1:SetRange(LOCATION_MZONE)
    e1:SetCountLimit(1)
    e1:SetCost(Cirn9.ap1)
    e1:SetTarget(cm.damtg)
    e1:SetOperation(cm.damop)
    c:RegisterEffect(e1)  
    --+4
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(m,1))
    e2:SetCategory(CATEGORY_DRAW+CATEGORY_COUNTER)
    e2:SetType(EFFECT_TYPE_IGNITION)
    e2:SetCountLimit(1)
    e2:SetRange(LOCATION_MZONE)
    e2:SetCost(Cirn9.ap2)
    e2:SetTarget(cm.sptg)
    e2:SetOperation(cm.spop)
    c:RegisterEffect(e2)  
    --Destory
    local e3=Effect.CreateEffect(c)
    e3:SetDescription(aux.Stringid(m,2))
    e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e3:SetCategory(CATEGORY_DESTROY+CATEGORY_DAMAGE)
    e3:SetType(EFFECT_TYPE_IGNITION)
    e3:SetCountLimit(1)
    e3:SetRange(LOCATION_MZONE)
    e3:SetCondition(Cirn9.clcon)
    e3:SetCost(Cirn9.clcost)
    e3:SetTarget(cm.destg)
    e3:SetOperation(cm.desop)
    c:RegisterEffect(e3)   
    cm.ClimaxAct=e3
end
function cm.damtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return true end
    Duel.SetTargetPlayer(1-tp)
    Duel.SetTargetParam(500)
    Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,500)
    Duel.SetOperationInfo(0,CATEGORY_COUNTER,nil,1,0,0xc99)
end
function cm.damop(e,tp,eg,ep,ev,re,r,rp)
    local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
    if Duel.Damage(p,d,REASON_EFFECT) and e:GetHandler():IsRelateToEffect(e) then
        Duel.BreakEffect()
        e:GetHandler():AddCounter(0xc99,1)
    end
end
function cm.spfilter(c,e,tp)
    return c:IsCanBeSpecialSummoned(e,0,tp,false,false) and c:IsSetCard(0xc99)
end
function cm.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chk==0 then return Duel.IsPlayerCanDraw(tp,1) end
    e:GetHandler():AddCounter(0xc99,1)
    Duel.SetTargetPlayer(tp)
    Duel.SetTargetParam(1)
    Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp)
    local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
    Duel.Draw(p,d,REASON_EFFECT)
    if Duel.GetFlagEffect(tp,m)<1 then 
        Duel.RegisterFlagEffect(tp,m,RESET_PHASE+PHASE_END,0,1)
        Duel.RegisterFlagEffect(tp,20100051,RESET_PHASE+PHASE_END,0,1)
        Duel.RegisterFlagEffect(tp,20100051,RESET_PHASE+PHASE_END,0,1)
        Duel.RegisterFlagEffect(tp,20100051,RESET_PHASE+PHASE_END,0,1)
        Duel.RegisterFlagEffect(tp,20100051,RESET_PHASE+PHASE_END,0,1)
        local ea=Duel.GetFlagEffect(tp,20100050)
        local eb=Duel.GetFlagEffect(tp,20100051)
        local ec=6-ea+eb
        Debug.Message("ReLive卡行动次数剩余"..ec.."次  DA☆ZE")
    end
end
function cm.retcon(e,tp,eg,ep,ev,re,r,rp)
    return Duel.GetTurnCount()==e:GetLabel() and e:GetOwner():GetFlagEffect(m)~=0
end
function cm.retop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetOwner()
    c:ResetEffect(EFFECT_SET_CONTROL,RESET_CODE)
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetCode(EFFECT_SET_CONTROL)
    e1:SetValue(c:GetOwner())
    e1:SetReset(RESET_EVENT+0xec0000)
    c:RegisterEffect(e1)
end
function cm.desfilter1(c,tp,column,line)
    local column1=aux.GetColumn(c,tp)
    local line1=Cirn9.GetLine(c)
    return (math.abs(column-column1)<=1) and (math.abs(line-line1)<=1) and c:GetFlagEffect(m+1)==0 and c:IsControler(1-tp)
end
function cm.desfilter(c,tp)
    local column=aux.GetColumn(c,tp)
    local line=Cirn9.GetLine(c)
    return Duel.IsExistingMatchingCard(cm.desfilter1,tp,0,LOCATION_ONFIELD,1,c,tp,column,line) and c:IsControler(1-tp)
end

function cm.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return chkc:IsOnField() and chkc:IsControler(1-tp) end
    if chk==0 then return Duel.IsExistingTarget(cm.desfilter,tp,0,LOCATION_ONFIELD,1,nil,tp) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
    local g=Duel.SelectTarget(tp,cm.desfilter,tp,0,LOCATION_ONFIELD,1,1,nil,tp)
    Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
    Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,0)
end
function cm.desop(e,tp,eg,ep,ev,re,r,rp)
    local revue=Cirn9.Climax(e,tp,eg,ep,ev,re,r,rp)
    if revue==0 then return
    elseif revue==1 then Cirn9.RevueBgm(tp) end 
    local tc=Duel.GetFirstTarget()
    local column=aux.GetColumn(tc,tp)
    local line=Cirn9.GetLine(tc)
    local sc=tc
    local sf=0
    if tc:IsRelateToEffect(e) and Duel.IsExistingMatchingCard(cm.desfilter1,tp,0,LOCATION_ONFIELD,1,tc,tp,column,line) then
        tc:RegisterFlagEffect(m+1,RESET_CHAIN,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(m,4))
        local g=Group.CreateGroup()
        local sg=Group.CreateGroup()
        while 1 do
            g=Duel.GetMatchingGroup(cm.desfilter1,tp,0,LOCATION_ONFIELD,nil,tp,column,line)
            sg=g:Select(tp,1,1,nil)
            sc=sg:GetFirst()
            sc:RegisterFlagEffect(m+1,RESET_CHAIN,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(m,4))
            Duel.HintSelection(sg)
            sf=sf+1
            column=aux.GetColumn(sc,tp)
            line=Cirn9.GetLine(sc)
            if Duel.IsExistingMatchingCard(cm.desfilter1,tp,0,LOCATION_ONFIELD,1,sc,tp,column,line) then
                if Duel.SelectYesNo(tp,aux.Stringid(m,5)) then 
                else break
                end
            else break
            end
        end 
        Duel.Destroy(sc,REASON_EFFECT)
        Duel.Damage(1-tp,400*sf,REASON_EFFECT)
    end
end