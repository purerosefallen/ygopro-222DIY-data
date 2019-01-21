--小黄
local m=12030021
local cm=_G["c"..m]
cm.rssetcode="yatori"
function cm.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(rscf.CheckLinkSetCard,"yatori"),1)
	local e1=rsef.STF(c,EVENT_SPSUMMON_SUCCESS,nil,nil,nil,"cd,uc",rscon.sumtype("link"),nil,nil,cm.limitop)
	e1:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_SINGLE)
	local e2=rsef.STF(c,EVENT_SPSUMMON_SUCCESS,nil,nil,nil,"cd,uc",rscon.sumtype("link",cm.sumfilter),nil,nil,cm.drop)
	e2:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_SINGLE)
	local e4=rsef.FTO(c,EVENT_SPSUMMON_SUCCESS,{m,0},nil,"se,th","de",LOCATION_MZONE,cm.thcon,cm.thcost,cm.thtg,cm.thop)
	local e5=rsef.FTO(c,EVENT_SUMMON_SUCCESS,{m,0},nil,"se,th","de",LOCATION_MZONE,cm.thcon,cm.thcost,cm.thtg,cm.thop)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_MATERIAL_CHECK)
	e3:SetValue(cm.matcheck)
	e2:SetLabelObject(e3)
	c:RegisterEffect(e3)
end
function cm.cfilter(c,zone)
	local seq=c:GetSequence()
	if c:IsLocation(LOCATION_MZONE) then
		if c:IsControler(1) then seq=seq+16 end
	else
		seq=c:GetPreviousSequence()
		if c:GetPreviousControler()==1 then seq=seq+16 end
	end
	return bit.extract(zone,seq)~=0 and c:CheckSetCard("yatori")
end
function cm.thcon(e,tp,eg,ep,ev,re,r,rp)
	local zone=Duel.GetLinkedZone(0)+(Duel.GetLinkedZone(1)<<0x10)
	return eg:IsExists(cm.cfilter,1,nil,zone)
end
function cm.thcost(e,tp,eg,ep,ev,re,r,rp,chk)   
	local c=e:GetHandler()
	if chk==0 then return Duel.GetTurnPlayer()~=tp or c:GetFlagEffect(m)==0 end
	c:RegisterFlagEffect(m,rsreset.est_pend,0,1)
end
function cm.thfilter(c)
	return c:IsType(TYPE_MONSTER) and c:CheckSetCard("yatori") and c:IsAbleToHand()
end
function cm.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function cm.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,cm.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if #g>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function cm.matcheck(e,c)
	local mat=c:GetMaterial()
	e:SetLabel(0)
	for tc in aux.Next(mat) do
		if tc:IsSummonType(SUMMON_TYPE_NORMAL) then e:SetLabel(1) end
		if tc:IsSummonType(SUMMON_TYPE_SPECIAL) and tc:GetTurnID()~=Duel.GetTurnCount() then e:SetLabel(1) end
	end
end
function cm.sumfilter(e,tp,re,rp,mat)
	return #mat>0 and e:GetLabelObject():GetLabel()==1
end
function cm.drop(e,tp)
	Duel.Draw(tp,1,REASON_EFFECT)
end
function cm.limitop(e,tp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetTargetRange(1,0)
	e1:SetTarget(cm.splimit)
	Duel.RegisterEffect(e1,tp)
end
function cm.splimit(e,c,sump,sumtype,sumpos,targetp,se)
	if not c:IsLocation(LOCATION_DECK+LOCATION_EXTRA) then return false end
	return not c:CheckSetCard("yatori")
end
