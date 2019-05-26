--超进合体！新干线！
if not pcall(function() require("expansions/script/c18008001") end) then require("script/c18008001") end
local m=18008009
local cm=_G["c"..m]
function cm.initial_effect(c)
	local e1=rsef.ACT(c,nil,nil,nil,"sp",nil,nil,rscost.reglabel(100),cm.tg,cm.act)
end
cm.rssetcode="Shinkansen"
function cm.rmfilter(c)
	return c:IsAbleToRemoveAsCost() and rssk.set(c)
end
function cm.spcheck(g,e,tp)
	return Duel.IsExistingMatchingCard(cm.spfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp,g)
end
function cm.spfilter(c,e,tp,g)
	return rssk.set(c) and c:IsType(TYPE_LINK) and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_LINK,tp,false,false) and ((not g and Duel.GetLocationCountFromEx(tp,tp,nil,c)>0) or (g and Duel.GetLocationCountFromEx(tp,tp,g,c)>0))
end
function cm.tg(e,tp,eg,ep,ev,re,r,rp,chk)	 
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(cm.rmfilter,tp,LOCATION_MZONE,0,nil)
	if chk==0 then
		if e:GetLabel()==100 then 
			return g:CheckSubGroup(cm.spcheck,2,2,e,tp)
		else
			return Duel.IsExistingMatchingCard(cm.spfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp)
		end
	end 
	if e:GetLabel()==100 then
		e:SetLabel(0)
		rsof.SelectHint(tp,"rm")
		local rg=g:SelectSubGroup(tp,cm.spcheck,false,2,2,e,tp)
		if Duel.Remove(rg,POS_FACEUP,REASON_COST+REASON_TEMPORARY)>0 then
			local og=Duel.GetOperatedGroup()
			local fid=c:GetFieldID()
			for tc in aux.Next(og) do
				tc:RegisterFlagEffect(m,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END+RESET_OPPO_TURN,0,1,fid)
			end
			og:KeepAlive()
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
			e1:SetCode(EVENT_PHASE+PHASE_END)
			e1:SetReset(RESET_PHASE+PHASE_END+RESET_OPPO_TURN)
			e1:SetLabelObject(og)
			e1:SetCountLimit(1) 
			e1:SetLabel(fid)
			e1:SetCondition(cm.retcon)
			e1:SetOperation(cm.retop)
			Duel.RegisterEffect(e1,tp)  
		end
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function cm.act(e,tp)
	rsof.SelectHint(tp,"sp")
	local sg=Duel.SelectMatchingCard(tp,cm.spfilter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp)
	if #sg>0 then rssf.SpecialSummon(sg,SUMMON_TYPE_LINK,tp,tp,false,false,POS_FACEUP,nil,rssf.SummonBuff(nil,nil,nil,nil,"rm")) end
end
function cm.retfilter(c,fid)
	return c:GetFlagEffectLabel(m)==fid
end
function cm.retcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetLabelObject():IsExists(cm.retfilter,1,nil,e:GetLabel()) and Duel.GetTurnPlayer()~=tp
end
function cm.retop(e,tp,eg,ep,ev,re,r,rp)
	local g=e:GetLabelObject():Filter(cm.retfilter,nil,e:GetLabel())
	for tc in aux.Next(g) do
		Duel.ReturnToField(tc)
	end
end