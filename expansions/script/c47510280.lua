--提亚马特·怨恨
function c47510280.initial_effect(c)
    --xyz summon
    c:EnableReviveLimit()
    aux.AddXyzProcedureLevelFree(c,c47510280.mfilter,c47510280.xyzcheck,3,3)
    --pendulum summon
    aux.EnablePendulumAttribute(c,false)    
    --twin element
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetRange(LOCATION_MZONE)
    e1:SetCode(EFFECT_IMMUNE_EFFECT)
    e1:SetCondition(c47510280.atkcon)
    e1:SetValue(c47510280.efilter)
    c:RegisterEffect(e1)
    local e2=Effect.CreateEffect(c)
    e2:SetType(TYPE_SPELL)
    e2:SetRange(LOCATION_MZONE)
    e2:SetCode(EFFECT_ATTACK_ALL)
    e2:SetCondition(c47510280.atkcon)
    e2:SetValue(1)
    c:RegisterEffect(e2)
    --danku no Tornado Disaster
    local e3=Effect.CreateEffect(c)
    e3:SetCategory(CATEGORY_DISABLE+CATEGORY_ATKCHANGE)
    e3:SetDescription(aux.Stringid(47510280,1))
    e3:SetType(EFFECT_TYPE_QUICK_O)
    e3:SetCode(EVENT_FREE_CHAIN)
    e3:SetRange(LOCATION_MZONE)
    e3:SetCountLimit(1)
    e3:SetCondition(c47510280.dkcon)
    e3:SetTarget(c47510280.dktg)
    e3:SetOperation(c47510280.dkop)
    c:RegisterEffect(e3)
    --senran no Tornado Disaster
    local e4=Effect.CreateEffect(c)
    e4:SetDescription(aux.Stringid(47510280,2))
    e4:SetType(EFFECT_TYPE_QUICK_O)
    e4:SetCode(EVENT_FREE_CHAIN)
    e4:SetRange(LOCATION_MZONE)
    e4:SetCountLimit(1)
    e4:SetCondition(c47510280.srcon)
    e4:SetOperation(c47510280.srop)
    c:RegisterEffect(e4)
    --quick pendulum
    local e5=Effect.CreateEffect(c)
    e5:SetDescription(aux.Stringid(47510280,0))
    e5:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e5:SetType(EFFECT_TYPE_QUICK_O)
    e5:SetCode(EVENT_FREE_CHAIN)
    e5:SetRange(LOCATION_PZONE)
    e5:SetCountLimit(1,47510280+EFFECT_COUNT_CODE_DUEL)
    e5:SetCondition(c47510280.pspcon)
    e5:SetOperation(c47510280.pspop)
    c:RegisterEffect(e5)
    --pendulum
    local e7=Effect.CreateEffect(c)
    e7:SetDescription(aux.Stringid(47510280,3))
    e7:SetCategory(CATEGORY_DESTROY)
    e7:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e7:SetCode(EVENT_DESTROYED)
    e7:SetProperty(EFFECT_FLAG_DELAY)
    e7:SetCondition(c47510280.pencon)
    e7:SetTarget(c47510280.pentg)
    e7:SetOperation(c47510280.penop)
    c:RegisterEffect(e7)  
end
c47510280.pendulum_level=9
function c47510280.mfilter(c)
    return c:GetOriginalLevel()>0 and (c:IsAttribute(ATTRIBUTE_WIND) or c:IsAttribute(ATTRIBUTE_DARK))
end
function c47510280.xyzcheck(g)
    return g:GetClassCount(Card.GetLevel)==g:GetCount()
end
function c47510280.atkcon(e,tp,eg,ep,ev,re,r,rp)
    return e:GetHandler():GetOverlayGroup():IsExists(Card.IsAttribute,1,nil,ATTRIBUTE_DARK) and e:GetHandler():GetOverlayGroup():IsExists(Card.IsAttribute,1,nil,ATTRIBUTE_WIND)
end
function c47510280.efilter(e,te)
    return te:GetOwner()~=e:GetOwner()
end
function c47510280.dkcon(e,tp,eg,ep,ev,re,r,rp)
    return e:GetHandler():GetOverlayGroup():IsExists(Card.IsAttribute,1,nil,ATTRIBUTE_WIND)
end
function c47510280.dktg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(Card.IsFaceup,tp,0,LOCATION_MZONE,1,nil) end
end
function c47510280.dkop(e,tp,eg,ep,ev,re,r,rp)
    local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,0,LOCATION_MZONE,nil)
    local tc=g:GetFirst()
    local c=e:GetHandler()
    while tc do
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
        local e3=Effect.CreateEffect(e:GetHandler())
        e3:SetType(EFFECT_TYPE_SINGLE)
        e3:SetCode(EFFECT_UPDATE_ATTACK)
        e3:SetValue(-4000)
        e3:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
        tc:RegisterEffect(e3)
        local e4=e3:Clone()
        e4:SetCode(EFFECT_UPDATE_DEFENSE)
        tc:RegisterEffect(e4)
        tc=g:GetNext()
        Duel.BreakEffect()
        c:RemoveOverlayCard(tp,1,1,REASON_EFFECT)
    end
    c:RemoveOverlayCard(tp,1,1,REASON_EFFECT)
end
function c47510280.srcon(e,tp,eg,ep,ev,re,r,rp)
    return e:GetHandler():GetOverlayGroup():IsExists(Card.IsAttribute,1,nil,ATTRIBUTE_DARK)
end
function c47510280.op1(e,tp,eg,ep,ev,re,r,rp)
    local e1=Effect.CreateEffect(e:GetHandler())
    e1:SetType(EFFECT_TYPE_FIELD)
    e1:SetCode(EFFECT_IMMUNE_EFFECT)
    e1:SetTargetRange(0,LOCATION_ONFIELD)
    e1:SetReset(RESET_PHASE+PHASE_END)
    e1:SetValue(c47510280.efilter1)
    Duel.RegisterEffect(e1,tp)
    Duel.BreakEffect()
    c:RemoveOverlayCard(tp,1,1,REASON_EFFECT)
end
function c47510280.efilter1(e,te)
    return te:GetOwnerPlayer()~=e:GetOwnerPlayer()
end 
function c47510280.pencon(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    return bit.band(r,REASON_EFFECT+REASON_BATTLE)~=0 and c:IsPreviousLocation(LOCATION_MZONE) and c:IsFaceup()
end
function c47510280.pentg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1) end
end
function c47510280.pcfilter(c)
    return c:IsType(TYPE_PENDULUM) and not c:IsForbidden()
end
function c47510280.penop(e,tp,eg,ep,ev,re,r,rp)
    local g=Duel.GetFieldGroup(tp,LOCATION_ONFIELD,0)
    if Duel.Destroy(g,REASON_EFFECT)~=0 and e:GetHandler():IsRelateToEffect(e) then
       if Duel.MoveToField(e:GetHandler(),tp,tp,LOCATION_SZONE,POS_FACEUP,true)~=0 then
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
        local g=Duel.SelectMatchingCard(tp,c47510280.pcfilter,tp,LOCATION_DECK,0,1,1,nil)
        if g:GetCount()>0 then
            Duel.MoveToField(g:GetFirst(),tp,tp,LOCATION_SZONE,POS_FACEUP,true)
        end 
        end
    end
end
function c47510280.pspcon(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
                if c==nil then return true end
                local eset={Duel.IsPlayerAffectedByEffect(tp,EFFECT_EXTRA_PENDULUM_SUMMON)}
                if PENDULUM_CHECKLIST&(0x1<<tp)~=0 and #eset==0 then return false end
                local rpz=Duel.GetFieldCard(tp,LOCATION_PZONE,1)
                if rpz==nil or c==rpz then return false end
                local lscale=c:GetLeftScale()
                local rscale=rpz:GetRightScale()
                if lscale>rscale then lscale,rscale=rscale,lscale end
                local loc=0
                if Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then loc=loc+LOCATION_HAND end
                if Duel.GetLocationCountFromEx(tp)>0 then loc=loc+LOCATION_EXTRA end
                if loc==0 then return false end
                local g=nil
                if og then
                    g=og:Filter(Card.IsLocation,nil,loc)
                else
                    g=Duel.GetFieldGroup(tp,loc,0)
                end
                return g:IsExists(aux.PConditionFilter,1,nil,e,tp,lscale,rscale,eset)
end
function c47510280.pspop(e,tp,eg,ep,ev,re,r,rp,sg,og)
    local c=e:GetHandler()
                local rpz=Duel.GetFieldCard(tp,LOCATION_PZONE,1)
                local lscale=c:GetLeftScale()
                local rscale=rpz:GetRightScale()
                if lscale>rscale then lscale,rscale=rscale,lscale end
                local eset={Duel.IsPlayerAffectedByEffect(tp,EFFECT_EXTRA_PENDULUM_SUMMON)}
                local tg=nil
                local loc=0
                local ft1=Duel.GetLocationCount(tp,LOCATION_MZONE)
                local ft2=Duel.GetLocationCountFromEx(tp)
                local ft=Duel.GetUsableMZoneCount(tp)
                local ect=c29724053 and Duel.IsPlayerAffectedByEffect(tp,29724053) and c29724053[tp]
                if ect and ect<ft2 then ft2=ect end
                if Duel.IsPlayerAffectedByEffect(tp,59822133) then
                    if ft1>0 then ft1=1 end
                    if ft2>0 then ft2=1 end
                    ft=1
                end
                if ft1>0 then loc=loc|LOCATION_HAND end
                if ft2>0 then loc=loc|LOCATION_EXTRA end
                if og then
                    tg=og:Filter(Card.IsLocation,nil,loc):Filter(aux.PConditionFilter,nil,e,tp,lscale,rscale,eset)
                else
                    tg=Duel.GetMatchingGroup(aux.PConditionFilter,tp,loc,0,nil,e,tp,lscale,rscale,eset)
                end
                local ce=nil
                local b1=PENDULUM_CHECKLIST&(0x1<<tp)==0
                local b2=#eset>0
                if b1 and b2 then
                    local options={1163}
                    for _,te in ipairs(eset) do
                        table.insert(options,te:GetDescription())
                    end
                    local op=Duel.SelectOption(tp,table.unpack(options))
                    if op>0 then
                        ce=eset[op]
                    end
                elseif b2 and not b1 then
                    local options={}
                    for _,te in ipairs(eset) do
                        table.insert(options,te:GetDescription())
                    end
                    local op=Duel.SelectOption(tp,table.unpack(options))
                    ce=eset[op+1]
                end
                if ce then
                    tg=tg:Filter(aux.PConditionExtraFilterSpecific,nil,e,tp,lscale,rscale,ce)
                end
                Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
                local g=tg:SelectSubGroup(tp,aux.PendOperationCheck,true,1,#tg,ft1,ft2,ft)
                if not g then return end
                if ce then
                    Duel.Hint(HINT_CARD,0,ce:GetOwner():GetOriginalCode())
                    ce:Reset()
                end
                Duel.HintSelection(Group.FromCards(c))
                Duel.HintSelection(Group.FromCards(rpz))
    for tc in aux.Next(g) do
        local bool=aux.PendulumSummonableBool(tc)
        Duel.SpecialSummonStep(tc,SUMMON_TYPE_PENDULUM,tp,tp,bool,bool,POS_FACEUP)
    end
    Duel.SpecialSummonComplete()
    for tc in aux.Next(g) do tc:CompleteProcedure() end
end