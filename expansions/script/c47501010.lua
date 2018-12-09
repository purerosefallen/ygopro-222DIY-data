--天女 姬塔
function c47501010.initial_effect(c)
    --synchro summon
    aux.AddSynchroProcedure(c,aux.FilterBoolFunction(Card.IsCode,47500000),aux.FilterBoolFunction(Card.IsType,TYPE_SYNCHRO),1,1)
    c:EnableReviveLimit()    
    --special summon rule
    local e0=Effect.CreateEffect(c)
    e0:SetType(EFFECT_TYPE_FIELD)
    e0:SetCode(EFFECT_SPSUMMON_PROC)
    e0:SetProperty(EFFECT_FLAG_UNCOPYABLE)
    e0:SetRange(LOCATION_EXTRA)
    e0:SetValue(SUMMON_TYPE_SYNCHRO)
    e0:SetCondition(c47501010.sprcon)
    e0:SetOperation(c47501010.sprop)
    c:RegisterEffect(e0) 
    --splimit
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_FIELD)
    e1:SetRange(LOCATION_PZONE)
    e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
    e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CANNOT_NEGATE)
    e1:SetTargetRange(1,0)
    e1:SetTarget(c47501010.psplimit)
    c:RegisterEffect(e1) 
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
    e2:SetCode(EVENT_CHAINING)
    e2:SetRange(LOCATION_PZONE)
    e2:SetOperation(c47501010.chainop)
    c:RegisterEffect(e2)   
    local e3=Effect.CreateEffect(c)
    e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
    e3:SetCode(EVENT_PRE_BATTLE_DAMAGE)
    e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
    e3:SetRange(LOCATION_PZONE)
    e3:SetTargetRange(0,1)
    e3:SetOperation(c47501010.damop)
    c:RegisterEffect(e3)   
    --salvage
    local e5=Effect.CreateEffect(c)
    e5:SetDescription(aux.Stringid(47501010,0))
    e5:SetCategory(CATEGORY_TOHAND)
    e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e5:SetCode(EVENT_SPSUMMON_SUCCESS)
    e5:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
    e5:SetCountLimit(1,47501910)
    e5:SetCondition(c47501010.thcon)
    e5:SetTarget(c47501010.thtg)
    e5:SetOperation(c47501010.thop)
    c:RegisterEffect(e5)
    local e7=Effect.CreateEffect(c)
    e7:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
    e7:SetCode(EVENT_BE_BATTLE_TARGET)
    e7:SetRange(LOCATION_MZONE)
    e7:SetCondition(c47501010.fcon)
    e7:SetOperation(c47501010.fop1)
    c:RegisterEffect(e7)
    local e9=Effect.CreateEffect(c)
    e9:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
    e9:SetCode(EVENT_BECOME_TARGET)
    e9:SetRange(LOCATION_MZONE)
    e9:SetCondition(c47501010.fcon)
    e9:SetTarget(c47501010.ftg)
    e9:SetOperation(c47501010.fop2)
    c:RegisterEffect(e9)
    local e8=Effect.CreateEffect(c)
    e8:SetType(EFFECT_TYPE_FIELD)
    e8:SetCode(EFFECT_UPDATE_ATTACK)
    e8:SetRange(LOCATION_MZONE)
    e8:SetCondition(c47501010.fcon1)
    e8:SetValue(2000)
    e8:SetTargetRange(LOCATION_MZONE,0)
    c:RegisterEffect(e8)
end
c47501010.card_code_list={47500000}
function c47501010.pefilter(c)
    return c:IsRace(RACE_WARRIOR) or c:IsRace(RACE_SPELLCASTER)
end
function c47501010.psplimit(e,c,tp,sumtp,sumpos)
    return not c47501010.pefilter(c) and bit.band(sumtp,SUMMON_TYPE_PENDULUM)==SUMMON_TYPE_PENDULUM
end
function c47501010.fusfilter1(c)
    return c:GetOriginalCode()==47500000
end
function c47501010.cfilter(c)
    return (c:IsCode(47500000) or c:GetOriginalCode()==47500000) and c:IsCanBeSynchroMaterial() and c:IsReleasable()
end
function c47501010.spfilter1(c,tp,g)
    return g:IsExists(c47501010.spfilter2,1,c,tp,c)
end
function c47501010.spfilter2(c,tp,mc)
    return (c:GetOriginalCode()==47500000 and mc:IsCode(47500000)
        or c:IsCode(47500000) and mc:GetOriginalCode()==47500000)
        and Duel.GetLocationCountFromEx(tp,tp,Group.FromCards(c,mc))>0
end
function c47501010.sprcon(e,c)
    if c==nil then return true end
    local tp=c:GetControler()
    local g=Duel.GetMatchingGroup(c47501010.cfilter,tp,LOCATION_MZONE,0,nil)
    return g:IsExists(c47501010.spfilter1,1,nil,tp,g)
end
function c47501010.sprop(e,tp,eg,ep,ev,re,r,rp,c)
    local g=Duel.GetMatchingGroup(c47501010.cfilter,tp,LOCATION_MZONE,0,nil)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
    local g1=g:FilterSelect(tp,c47501010.spfilter1,1,1,nil,tp,g)
    local mc=g1:GetFirst()
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
    local g2=g:FilterSelect(tp,c47501010.spfilter2,1,1,mc,tp,mc)
    g1:Merge(g2)
    Duel.Release(g1,REASON_COST+REASON_MATERIAL+REASON_SYNCHRO)
end
function c47501010.damop(e,tp,eg,ep,ev,re,r,rp)
    Duel.ChangeBattleDamage(ep,ev*2)
end
function c47501010.chainop(e,tp,eg,ep,ev,re,r,rp)
    if re:IsHasCategory(CATEGORY_DAMAGE) and ep==tp then
        Duel.SetChainLimit(c47501010.chainlm)
    end
end
function c47501010.chainlm(e,rp,tp)
    return tp==rp
end
function c47501010.thcon(e,tp,eg,ep,ev,re,r,rp)
    return e:GetHandler():IsSummonType(SUMMON_TYPE_SYNCHRO)
end
function c47501010.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c47501010.penfiltert,tp,LOCATION_EXTRA,0,1,nil) end
end
function c47501010.penfiltert(c)
    return c:IsType(TYPE_PENDULUM) and c:IsAbleToHand() and c:IsFaceup()
end
function c47501010.thop(e,tp,eg,ep,ev,re,r,rp)
    local g=Duel.SelectMatchingCard(tp,c47501010.penfiltert,tp,LOCATION_EXTRA,0,2,2,nil)
    local tc=g:GetFirst()
    while tc do
        Duel.SendtoHand(tc,nil,REASON_EFFECT)
        tc=g:GetNext()
    end
    local c=e:GetHandler()
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(47501010,2))
    e1:SetType(EFFECT_TYPE_FIELD)
    e1:SetCode(EFFECT_SPSUMMON_PROC_G)
    e1:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE)
    e1:SetRange(LOCATION_PZONE)
    e1:SetCountLimit(1,47501010)
    e1:SetCondition(c47501010.pencon1)
    e1:SetOperation(c47501010.penop1)
    e1:SetValue(SUMMON_TYPE_PENDULUM)
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_GRANT)
    e2:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
    e2:SetTargetRange(LOCATION_SZONE,0)
    e2:SetTarget(c47501010.eftg)
    e2:SetLabelObject(e1)
    e2:SetReset(RESET_PHASE+PHASE_END)
    Duel.RegisterEffect(e2,tp)
    local e3=Effect.CreateEffect(c)
    e3:SetDescription(aux.Stringid(47501010,2))
    e3:SetType(EFFECT_TYPE_FIELD)
    e3:SetCode(EFFECT_SPSUMMON_PROC_G)
    e3:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE)
    e3:SetRange(LOCATION_PZONE)
    e3:SetCountLimit(1,47501010)
    e3:SetCondition(c47501010.pencon2)
    e3:SetOperation(c47501010.penop2)
    e3:SetValue(SUMMON_TYPE_PENDULUM)
    local e4=Effect.CreateEffect(c)
    e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_GRANT)
    e4:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
    e4:SetTargetRange(0,LOCATION_SZONE)
    e4:SetTarget(c47501010.eftg2)
    e4:SetLabelObject(e3)
    e4:SetReset(RESET_PHASE+PHASE_END)
    Duel.RegisterEffect(e4,tp)    
end
function c47501010.eftg(e,c)
    return c==Duel.GetFieldCard(e:GetHandlerPlayer(),LOCATION_PZONE,0)
end
function c47501010.eftg2(e,c)
    local rpz=Duel.GetFieldCard(1-e:GetHandlerPlayer(),LOCATION_PZONE,1)
    return c==Duel.GetFieldCard(1-e:GetHandlerPlayer(),LOCATION_PZONE,0)
        and rpz
        and c:GetFlagEffectLabel(31531170)==rpz:GetFieldID()
        and rpz:GetFlagEffectLabel(31531170)==c:GetFieldID()
end
function c47501010.penfilter(c,e,tp,lscale,rscale)
    return aux.IsCodeListed(c,47500000) and aux.PConditionFilter(c,e,tp,lscale,rscale)
end
function c47501010.pencon1(e,c,og)
    if c==nil then return true end
    local tp=c:GetControler()
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
    return g:IsExists(c47501010.penfilter,1,nil,e,tp,lscale,rscale)
end
function c47501010.penop1(e,tp,eg,ep,ev,re,r,rp,c,sg,og)
    Duel.Hint(HINT_CARD,0,47501010)
    local rpz=Duel.GetFieldCard(tp,LOCATION_PZONE,1)
    local lscale=c:GetLeftScale()
    local rscale=rpz:GetRightScale()
    if lscale>rscale then lscale,rscale=rscale,lscale end
    local ft1=Duel.GetLocationCount(tp,LOCATION_MZONE)
    local ft2=Duel.GetLocationCountFromEx(tp)
    local ft=Duel.GetUsableMZoneCount(tp)
    if Duel.IsPlayerAffectedByEffect(tp,59822133) then
        if ft1>0 then ft1=1 end
        if ft2>0 then ft2=1 end
        ft=1
    end
    local loc=0
    if ft1>0 then loc=loc+LOCATION_HAND end
    if ft2>0 then loc=loc+LOCATION_EXTRA end
    local tg=nil
    if og then
        tg=og:Filter(Card.IsLocation,nil,loc):Filter(c47501010.penfilter,nil,e,tp,lscale,rscale)
    else
        tg=Duel.GetMatchingGroup(c47501010.penfilter,tp,loc,0,nil,e,tp,lscale,rscale)
    end
    ft1=math.min(ft1,tg:FilterCount(Card.IsLocation,nil,LOCATION_HAND))
    ft2=math.min(ft2,tg:FilterCount(Card.IsLocation,nil,LOCATION_EXTRA))
    local ect=c29724053 and Duel.IsPlayerAffectedByEffect(tp,29724053) and c29724053[tp]
    if ect and ect<ft2 then ft2=ect end
    while true do
        local ct1=tg:FilterCount(Card.IsLocation,nil,LOCATION_HAND)
        local ct2=tg:FilterCount(Card.IsLocation,nil,LOCATION_EXTRA)
        local ct=ft
        if ct1>ft1 then ct=math.min(ct,ft1) end
        if ct2>ft2 then ct=math.min(ct,ft2) end
        if ct<=0 then break end
        if sg:GetCount()>0 and not Duel.SelectYesNo(tp,210) then ft=0 break end
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
        local g=tg:Select(tp,1,ct,nil)
        tg:Sub(g)
        sg:Merge(g)
        if g:GetCount()<ct then ft=0 break end
        ft=ft-g:GetCount()
        ft1=ft1-g:FilterCount(Card.IsLocation,nil,LOCATION_HAND)
        ft2=ft2-g:FilterCount(Card.IsLocation,nil,LOCATION_EXTRA)
    end
    if ft>0 then
        local tg1=tg:Filter(Card.IsLocation,nil,LOCATION_HAND)
        local tg2=tg:Filter(Card.IsLocation,nil,LOCATION_EXTRA)
        if ft1>0 and ft2==0 and tg1:GetCount()>0 and (sg:GetCount()==0 or Duel.SelectYesNo(tp,210)) then
            local ct=math.min(ft1,ft)
            Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
            local g=tg1:Select(tp,1,ct,nil)
            sg:Merge(g)
        end
        if ft1==0 and ft2>0 and tg2:GetCount()>0 and (sg:GetCount()==0 or Duel.SelectYesNo(tp,210)) then
            local ct=math.min(ft2,ft)
            Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
            local g=tg2:Select(tp,1,ct,nil)
            sg:Merge(g)
        end
    end
    Duel.HintSelection(Group.FromCards(c))
    Duel.HintSelection(Group.FromCards(rpz))
end
function c47501010.pencon2(e,c,og)
    if c==nil then return true end
    local tp=e:GetOwnerPlayer()
    local rpz=Duel.GetFieldCard(1-tp,LOCATION_PZONE,1)
    if rpz==nil or rpz:GetFieldID()~=c:GetFlagEffectLabel(31531170) then return false end
    local lscale=c:GetLeftScale()
    local rscale=rpz:GetRightScale()
    if lscale>rscale then lscale,rscale=rscale,lscale end
    local ft=Duel.GetLocationCountFromEx(tp)
    if ft<=0 then return false end
    if og then
        return og:IsExists(c47501010.penfilter,1,nil,e,tp,lscale,rscale)
    else
        return Duel.IsExistingMatchingCard(c47501010.penfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp,lscale,rscale)
    end
end
function c47501010.penop2(e,tp,eg,ep,ev,re,r,rp,c,sg,og)
    Duel.Hint(HINT_CARD,0,31531170)
    Duel.Hint(HINT_CARD,0,47501010)
    local tp=e:GetOwnerPlayer()
    local rpz=Duel.GetFieldCard(1-tp,LOCATION_PZONE,1)
    local lscale=c:GetLeftScale()
    local rscale=rpz:GetRightScale()
    if lscale>rscale then lscale,rscale=rscale,lscale end
    local ft=Duel.GetLocationCountFromEx(tp)
    if Duel.IsPlayerAffectedByEffect(tp,59822133) then ft=1 end
    local ect=c29724053 and Duel.IsPlayerAffectedByEffect(tp,29724053) and c29724053[tp]
    if ect~=nil then ft=math.min(ft,ect) end
    if og then
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
        local g=og:FilterSelect(tp,c47501010.penfilter,1,ft,nil,e,tp,lscale,rscale)
        sg:Merge(g)
    else
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
        local g=Duel.SelectMatchingCard(tp,c47501010.penfilter,tp,LOCATION_EXTRA,0,1,ft,nil,e,tp,lscale,rscale)
        sg:Merge(g)
    end
    Duel.HintSelection(Group.FromCards(c))
    Duel.HintSelection(Group.FromCards(rpz))
end
function c47501010.fcon(e)
    return e:GetHandler():GetFlagEffect(47501010)<1
end
function c47501010.fcon1(e)
    return e:GetHandler():GetFlagEffect(47501010)==1
end
function c47501010.fop1(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if Duel.NegateAttack() then
    c:RegisterFlagEffect(47501010,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1)
    end
end
function c47501010.ftg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return true end
    Duel.SetOperationInfo(0,CATEGORY_DISABLE,eg,1,0,0)
end
function c47501010.fop2(e,tp,eg,ep,ev,re,r,rp,chk)
    local c=e:GetHandler()
    if Duel.NegateEffect(ev) then
    c:RegisterFlagEffect(47501010,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1)
    end
end