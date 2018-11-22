--天才美少女炼金术师
function c47510231.initial_effect(c)
    aux.EnablePendulumAttribute(c,false) 
    --fusion material
    c:EnableReviveLimit()
    aux.AddFusionProcFunRep(c,c47510231.ffilter,2,false)
    --special summon rule
    local e0=Effect.CreateEffect(c)
    e0:SetType(EFFECT_TYPE_FIELD)
    e0:SetCode(EFFECT_SPSUMMON_PROC)
    e0:SetProperty(EFFECT_FLAG_UNCOPYABLE)
    e0:SetRange(LOCATION_EXTRA)
    e0:SetValue(SUMMON_TYPE_FUSION)
    e0:SetCondition(c47510231.spcon)
    e0:SetOperation(c47510231.spop)
    c:RegisterEffect(e0)  
    --splimit
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_FIELD)
    e1:SetRange(LOCATION_PZONE)
    e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
    e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CANNOT_DISABLE)
    e1:SetTargetRange(1,0)
    e1:SetTarget(c47510231.splimit)
    c:RegisterEffect(e1) 
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_IGNITION)
    e2:SetRange(LOCATION_PZONE)
    e2:SetCountLimit(1,47510232)
    e2:SetTarget(c47510231.tftg)
    e2:SetOperation(c47510231.tfop)
    c:RegisterEffect(e2)
    local e3=Effect.CreateEffect(c)
    e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
    e3:SetCode(EVENT_SPSUMMON_SUCCESS)
    e3:SetOperation(c47510231.penop)
    c:RegisterEffect(e3)
    --tohand
    local e4=Effect.CreateEffect(c)
    e4:SetDescription(aux.Stringid(47510231,0))
    e4:SetCategory(CATEGORY_TOHAND)
    e4:SetType(EFFECT_TYPE_IGNITION)
    e4:SetRange(LOCATION_MZONE)
    e4:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e4:SetCountLimit(1)
    e4:SetTarget(c47510231.thtg)
    e4:SetOperation(c47510231.thop)
    c:RegisterEffect(e4)
end
function c47510231.ffilter(c)
    return c:IsType(TYPE_PENDULUM) and c:IsSetCard(0x5da)
end
function c47510231.spfilter(c,fc)
    return c47510231.ffilter(c) and c:IsCanBeFusionMaterial(fc)
end
function c47510231.spfilter1(c,tp,g)
    return g:IsExists(c47510231.spfilter2,1,c,tp,c)
end
function c47510231.spfilter2(c,tp,mc)
    return Duel.GetLocationCountFromEx(tp,tp,Group.FromCards(c,mc))>0
end
function c47510231.spcon(e,c)
    if c==nil then return true end
    local tp=c:GetControler()
    local g=Duel.GetReleaseGroup(tp):Filter(c47510231.spfilter,nil,c)
    return g:IsExists(c47510231.spfilter1,1,nil,tp,g) and c:IsFacedown()
end
function c47510231.spop(e,tp,eg,ep,ev,re,r,rp,c)
    local g=Duel.GetReleaseGroup(tp):Filter(c47510231.spfilter,nil,c)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
    local g1=g:FilterSelect(tp,c47510231.spfilter1,1,1,nil,tp,g)
    local mc=g1:GetFirst()
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
    local g2=g:FilterSelect(tp,c47510231.spfilter2,1,1,mc,tp,mc)
    g1:Merge(g2)
    c:SetMaterial(g1)
    Duel.Release(g1,REASON_COST+REASON_FUSION+REASON_MATERIAL)
end
function c47510231.splimit(e,c,tp,sumtp,sumpos)
    return not c:IsType(TYPE_PENDULUM)
end
function c47510231.tffilter(c)
    return (c:IsSetCard(0x5de) or c:IsSetCard(0x5da)) and c:IsType(TYPE_PENDULUM) and c:IsFaceup()
end
function c47510231.tftg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c47510231.tffilter,tp,LOCATION_EXTRA,0,1,nil) end
end
function c47510231.tfop(e,tp,eg,ep,ev,re,r,rp)
    if Duel.GetLocationCount(tp,LOCATION_SZONE)<1 then return end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
    local g=Duel.SelectMatchingCard(tp,c47510231.tffilter,tp,LOCATION_EXTRA,0,1,1,nil)
    local tc=g:GetFirst()
    if tc then
        Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
        local e2=Effect.CreateEffect(tc)
        e2:SetType(EFFECT_TYPE_SINGLE)
        e2:SetRange(LOCATION_SZONE)
        e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE)
        e2:SetCode(EFFECT_LINK_SPELL_KOISHI)
        e2:SetValue(LINK_MARKER_TOP+LINK_MARKER_TOP_RIGHT)
        e2:SetReset(RESET_EVENT+RESETS_STANDARD)
        tc:RegisterEffect(e2)
    end
end
function c47510231.penop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_FIELD)
    e1:SetCode(EFFECT_SPSUMMON_PROC_G)
    e1:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE)
    e1:SetRange(LOCATION_PZONE)
    e1:SetCountLimit(1,47510231)
    e1:SetCondition(c47510231.pencon1)
    e1:SetOperation(c47510231.penop1)
    e1:SetValue(SUMMON_TYPE_PENDULUM)
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_GRANT)
    e2:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
    e2:SetTargetRange(LOCATION_SZONE,0)
    e2:SetTarget(c47510231.eftg)
    e2:SetLabelObject(e1)
    e2:SetReset(RESET_PHASE+PHASE_END)
    Duel.RegisterEffect(e2,tp)
    local e3=Effect.CreateEffect(c)
    e3:SetType(EFFECT_TYPE_FIELD)
    e3:SetCode(EFFECT_SPSUMMON_PROC_G)
    e3:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE)
    e3:SetRange(LOCATION_PZONE)
    e3:SetCountLimit(1,47510231)
    e3:SetCondition(c47510231.pencon2)
    e3:SetOperation(c47510231.penop2)
    e3:SetValue(SUMMON_TYPE_PENDULUM)
    local e4=Effect.CreateEffect(c)
    e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_GRANT)
    e4:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
    e4:SetTargetRange(0,LOCATION_SZONE)
    e4:SetTarget(c47510231.eftg2)
    e4:SetLabelObject(e3)
    e4:SetReset(RESET_PHASE+PHASE_END)
    Duel.RegisterEffect(e4,tp)
end
function c47510231.eftg(e,c)
    return c==Duel.GetFieldCard(e:GetHandlerPlayer(),LOCATION_PZONE,0)
end
function c47510231.eftg2(e,c)
    local rpz=Duel.GetFieldCard(1-e:GetHandlerPlayer(),LOCATION_PZONE,1)
    return c==Duel.GetFieldCard(1-e:GetHandlerPlayer(),LOCATION_PZONE,0)
        and rpz
        and c:GetFlagEffectLabel(31531170)==rpz:GetFieldID()
        and rpz:GetFlagEffectLabel(31531170)==c:GetFieldID()
end
function c47510231.penfilter(c,e,tp,lscale,rscale)
    return c:IsType(TYPE_PENDULUM) and aux.PConditionFilter(c,e,tp,lscale,rscale) and c:IsLevelAbove(7)
end
function c47510231.pencon1(e,c,og)
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
    return g:IsExists(c47510231.penfilter,1,nil,e,tp,lscale,rscale)
end
function c47510231.penop1(e,tp,eg,ep,ev,re,r,rp,c,sg,og)
    Duel.Hint(HINT_CARD,0,47510231)
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
        tg=og:Filter(Card.IsLocation,nil,loc):Filter(c47510231.penfilter,nil,e,tp,lscale,rscale)
    else
        tg=Duel.GetMatchingGroup(c47510231.penfilter,tp,loc,0,nil,e,tp,lscale,rscale)
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
function c47510231.pencon2(e,c,og)
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
        return og:IsExists(c47510231.penfilter,1,nil,e,tp,lscale,rscale)
    else
        return Duel.IsExistingMatchingCard(c47510231.penfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp,lscale,rscale)
    end
end
function c47510231.penop2(e,tp,eg,ep,ev,re,r,rp,c,sg,og)
    Duel.Hint(HINT_CARD,0,31531170)
    Duel.Hint(HINT_CARD,0,47510231)
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
        local g=og:FilterSelect(tp,c47510231.penfilter,1,ft,nil,e,tp,lscale,rscale)
        sg:Merge(g)
    else
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
        local g=Duel.SelectMatchingCard(tp,c47510231.penfilter,tp,LOCATION_EXTRA,0,1,ft,nil,e,tp,lscale,rscale)
        sg:Merge(g)
    end
    Duel.HintSelection(Group.FromCards(c))
    Duel.HintSelection(Group.FromCards(rpz))
end
function c47510231.thfilter(c)
    return c:IsFaceup() and c:IsType(TYPE_PENDULUM)
end
function c47510231.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chk==0 then return Duel.IsExistingTarget(c47510231.thfilter,tp,LOCATION_MZONE+LOCATION_PZONE,LOCATION_MZONE+LOCATION_PZONE,2,nil) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
    local g=Duel.SelectTarget(tp,c47510231.thfilter,tp,LOCATION_MZONE+LOCATION_PZONE,LOCATION_MZONE+LOCATION_PZONE,2,2,nil)
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,2,0,0)
end
function c47510231.thop(e,tp,eg,ep,ev,re,r,rp)
    local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
    if Duel.SendtoHand(g,nil,REASON_EFFECT)~=0 and Duel.IsExistingTarget(Card.IsAbleToHand,tp,0,LOCATION_ONFIELD,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(47510231,0)) then
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
        local g1=Duel.SelectMatchingCard(tp,Card.IsAbleToHand,tp,0,LOCATION_ONFIELD,1,1,nil)
        if g1:GetCount()>0 then
            Duel.HintSelection(g1)
            Duel.SendtoHand(g1,tp,REASON_EFFECT)
        end
    end
end
function c47510231.tpcon(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    return c:IsPreviousLocation(LOCATION_MZONE) and c:IsFaceup()
end
function c47510231.tptg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1) end
end
function c47510231.tpop(e,tp,eg,ep,ev,re,r,rp)
    if not Duel.CheckLocation(tp,LOCATION_PZONE,0) and not Duel.CheckLocation(tp,LOCATION_PZONE,1) then return false end
    local c=e:GetHandler()
    if c:IsRelateToEffect(e) then
        Duel.MoveToField(c,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
    end
end