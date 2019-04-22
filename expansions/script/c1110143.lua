--消逝的幻境
function c1110143.initial_effect(c)
--
	aux.EnablePendulumAttribute(c)
--
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(1110143,0))
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC_G)
	e1:SetRange(LOCATION_PZONE)
	e1:SetCondition(c1110143.PendCondition())
	e1:SetOperation(c1110143.PendOperation())
	e1:SetValue(SUMMON_TYPE_RITUAL)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_GRANT)
	e2:SetRange(LOCATION_PZONE)
	e2:SetTargetRange(LOCATION_SZONE,0)
	e2:SetTarget(c1110143.tg2)
	e2:SetLabelObject(e1)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetCode(1110143)
	e3:SetRange(LOCATION_PZONE)
	c:RegisterEffect(e3)
--
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e4:SetRange(LOCATION_PZONE)
	e4:SetCode(EFFECT_IMMUNE_EFFECT)
	e4:SetValue(c1110143.tg4)
	c:RegisterEffect(e4)
--
end
function c1110143.PConditionFilter(c,e,tp,lscale,rscale,eset)
	local lv=0
	if c.pendulum_level then
		lv=c.pendulum_level
	else
		lv=c:GetLevel()
	end
	return (c:IsLocation(LOCATION_HAND) or (c:IsFaceup() and c:IsType(TYPE_PENDULUM))) and c:IsType(TYPE_RITUAL)
		and lv>lscale and lv<rscale
		and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_RITUAL,tp,bool,true)
		and (PENDULUM_CHECKLIST&(0x1<<tp)==0
			or aux.PConditionExtraFilter(c,e,tp,lscale,rscale,eset))
		and not c:IsForbidden()
end
function c1110143.PendCondition()
	return
	function(e,c,og)
		if c==nil then return true end
		local tp=c:GetControler()
		local eset={Duel.IsPlayerAffectedByEffect(tp,EFFECT_EXTRA_PENDULUM_SUMMON)}
		if PENDULUM_CHECKLIST&(0x1<<tp)~=0 and #eset==0 then return false end
		local rpz=Duel.GetFieldCard(tp,LOCATION_PZONE,1)
		if rpz==nil or c==rpz then return false end
		local lscale=c:GetLeftScale()
		local rscale=rpz:GetRightScale()
		if lscale>rscale then lscale,rscale=rscale,lscale end
		local loc=0
		if Duel.GetMZoneCount(tp)>0 then loc=loc+LOCATION_HAND end
		if Duel.GetLocationCountFromEx(tp)>0 then loc=loc+LOCATION_EXTRA end
		if loc==0 then return false end
		local g=nil
		if og then
			g=og:Filter(Card.IsLocation,nil,loc)
		else
			g=Duel.GetFieldGroup(tp,loc,0)
		end
		return g:IsExists(c1110143.PConditionFilter,1,nil,e,tp,lscale,rscale,eset)
	end
end
function c1110143.PendOperation()
	return
	function(e,tp,eg,ep,ev,re,r,rp,c,sg,og)
		local c=e:GetHandler()
		local rpz=Duel.GetFieldCard(tp,LOCATION_PZONE,1)
		local lscale=c:GetLeftScale()
		local rscale=rpz:GetRightScale()
		if lscale>rscale then lscale,rscale=rscale,lscale end
		local eset={Duel.IsPlayerAffectedByEffect(tp,EFFECT_EXTRA_PENDULUM_SUMMON)}
		local tg=nil
		local loc=0
		local ft1=Duel.GetMZoneCount(tp)
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
			tg=og:Filter(Card.IsLocation,nil,loc):Filter(c1110143.PConditionFilter,nil,e,tp,lscale,rscale,eset)
		else
			tg=Duel.GetMatchingGroup(c1110143.PConditionFilter,tp,loc,0,nil,e,tp,lscale,rscale,eset)
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
		aux.GCheckAdditional=aux.PendOperationCheck(ft1,ft2,ft)
		local g=tg:SelectSubGroup(tp,aux.TRUE,true,1,math.min(#tg,ft),ft1,ft2,ft)
		aux.GCheckAdditional=nil
		if not g then return end
		local fid=c:GetFieldID()
		local gc=g:GetFirst()
		while gc do
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_UNRELEASABLE_SUM)
			e1:SetValue(1)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			e1:SetReset(RESET_EVENT+0xfe0000)
			gc:RegisterEffect(e1,true)
			local e2=e1:Clone()
			e2:SetCode(EFFECT_UNRELEASABLE_NONSUM)
			gc:RegisterEffect(e2,true)
			local e3=e2:Clone()
			e3:SetCode(EFFECT_CANNOT_BE_SYNCHRO_MATERIAL)
			gc:RegisterEffect(e3,true)
			local e4=e3:Clone()
			e4:SetCode(EFFECT_CANNOT_BE_XYZ_MATERIAL)
			gc:RegisterEffect(e4,true)
			local e5=e4:Clone()
			e5:SetCode(EFFECT_CANNOT_BE_FUSION_MATERIAL)
			gc:RegisterEffect(e5,true)
			local e6=e5:Clone()
			e6:SetCode(EFFECT_CANNOT_BE_LINK_MATERIAL)
			gc:RegisterEffect(e6,true)
			gc:RegisterFlagEffect(1110143,RESET_EVENT+0xfe0000,0,1,fid)
			gc=g:GetNext()
		end
		g:KeepAlive()
		local e7=Effect.CreateEffect(c)
		e7:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e7:SetCode(EVENT_PHASE+PHASE_END)
		e7:SetCountLimit(1)
		e7:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
		e7:SetLabel(fid)
		e7:SetLabelObject(g)
		e7:SetCondition(c1110143.con1_7)
		e7:SetOperation(c1110143.op1_7)
		Duel.RegisterEffect(e7,tp)
		if ce then
			Duel.Hint(HINT_CARD,0,ce:GetOwner():GetOriginalCode())
			ce:Reset()
		else
			PENDULUM_CHECKLIST=PENDULUM_CHECKLIST|(0x1<<tp)
		end
		sg:Merge(g)
		Duel.HintSelection(Group.FromCards(c))
		Duel.HintSelection(Group.FromCards(rpz))
	end
end
function c1110143.con1_7(e,tp,eg,ep,ev,re,r,rp)
	local check=0
	local g=e:GetLabelObject()
	local tc=g:GetFirst()
	while tc do
		if tc:GetFlagEffectLabel(1110143)==e:GetLabel() then
			check=1
		end
		tc=g:GetNext()
	end
	if check~=1 then
		e:Reset()
		return false
	else return true end
end
function c1110143.ofilter1_7(c,fid)
	return c:GetFlagEffectLabel(1110143)==fid
end
function c1110143.op1_7(e,tp,eg,ep,ev,re,r,rp)
	local fid=e:GetLabel()
	local g=e:GetLabelObject()
	local sg=g:Filter(c1110143.ofilter1_7,nil,fid)
	Duel.SendtoHand(sg,nil,REASON_EFFECT)
end
function c1110143.tg2(e,c)
	return c:IsLocation(LOCATION_PZONE) and c~=e:GetHandler()
		and not c:IsHasEffect(1110143)
end
--
function c1110143.tg4(e,te)
	return te:GetOwner()~=e:GetOwner() and te:GetOwnerPlayer()==e:GetOwnerPlayer()
end
--