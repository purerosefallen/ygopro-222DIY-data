--神祭小狐 河狐神
if not pcall(function() require("expansions/script/c33331100") end) then require("script/c33331100") end
local m=33331107
local cm=_G["c"..m]
function cm.initial_effect(c)
	aux.AddLinkProcedure(c,nil,2,2,cm.lcheck)
	c:EnableReviveLimit()
	local e1=rsef.I(c,{m,0},1,"th",nil,LOCATION_MZONE,nil,nil,rstg.target(rsop.list(cm.thfilter,"th",LOCATION_EXTRA)),cm.thop)
	--control
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(m,1))
	e3:SetCategory(CATEGORY_CONTROL)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCondition(cm.ctcon)
	e3:SetTarget(cm.cttg)
	e3:SetOperation(cm.ctop)
	c:RegisterEffect(e3)
end
function cm.lcheck(g,lc)
	return g:IsExists(Card.IsLinkRace,1,nil,RACE_BEAST)
end
function cm.thfilter(c)
	return rslf.filter2(c) and c:IsType(TYPE_PENDULUM) and c:IsAbleToHand()
end
function cm.thop(e,tp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,cm.thfilter,tp,LOCATION_EXTRA,0,1,1,nil)
	if #g>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function cm.ctcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return not eg:IsContains(c) and eg:FilterCount(cm.cfilter,nil,c)==2
end
function cm.cfilter(c,ec)
	if c:IsLocation(LOCATION_MZONE) then
		return ec:GetLinkedGroup():IsContains(c)
	else
		return bit.extract(ec:GetLinkedZone(c:GetPreviousControler()),c:GetPreviousSequence())~=0
	end
end
function cm.cttg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return eg:IsExists(Card.IsControlerCanBeChanged,1,nil) end
	local g=eg:Filter(cm.cfilter,nil,e:GetHandler())
	Duel.SetTargetCard(g)
	Duel.SetOperationInfo(0,CATEGORY_CONTROL,eg,1,0,0)
end
function cm.ctop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=rsgf.GetTargetGroup()
	if #g<=0 then return end
	Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_CONTROL)
	local tc=g:FilterSelect(1-tp,Card.IsControlerCanBeChanged,1,1,nil):GetFirst()
	if not tc or not Duel.GetControl(tc,1-tp) then return end
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_MUST_BE_XMATERIAL)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(1,0)
	e1:SetReset(rsreset.est)
	tc:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_MUST_BE_LMATERIAL)
	tc:RegisterEffect(e2)
end